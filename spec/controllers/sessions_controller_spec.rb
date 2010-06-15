require 'spec_helper'

describe SessionsController do
  describe 'GET /show' do
    before do
      stub(controller).authenticate!
    end

    context 'signed in successfully' do
      before do
        get :show
      end

      it { response.should redirect_to(dashboard_path) }
    end

    context 'signed in successfully with return_to' do
      before do
        session[:return_to] = 'http://example.com/return_to'
        get :show
      end

      it { response.should redirect_to('http://example.com/return_to') }
    end
  end

  describe 'GET /unauthenticated' do
    context 'redirect back from Twitter with credentials' do
      before do
        stub(token = Object.new) {
          token  { 'alpha' }
          secret { 'bravo' }
          params { {:user_id => 1234} }
        }

        stub(controller).warden.stub!.env {
          {'warden.options' => {:oauth => {:twitter => {:access_token => token}}}}
        }

        stub.instance_of(Twitter::Base).user {
          Hashie::Mash.new(
            :name              => 'Keita Urashima',
            :url               => 'http://ursm.jp/',
            :screen_name       => 'ursm',
            :profile_image_url => 'http://example.com/ursm.png'
          )
        }

        get :unauthenticated
      end

      it { response.should redirect_to(new_account_path) }
      it { session[:params_from_authenticator][:twitter_user_id].should == 1234 }
      it { session[:params_from_authenticator][:full_name].should == 'Keita Urashima' }
      it { session[:params_from_authenticator][:website].should == 'http://ursm.jp/' }
      it { session[:params_from_authenticator][:avatar_type].should == 'twitter' }
      it { Redis::Value.new('twitter/users/1234', Redis::Objects.redis, :marshal => true).value.keys.should =~ %w(screen_name profile_image_url) }
    end

    context 'redirect back from OpenID provider with credentials' do
      before do
        stub(res = Object.new).identity_url { 'http://ursm.jp/' }

        stub(controller).warden.stub!.env {
          {'warden.options' => {:openid => {:response => res}}}
        }

        get :unauthenticated
      end

      it { response.should redirect_to(new_account_path) }
      it { session[:params_from_authenticator][:identity_url].should == 'http://ursm.jp/' }
    end

    context 'authentication failed' do
      before do
        stub(controller).warden.stub! {
          env { {'warden.options' => {}} }
          message { 'something' }
        }

        get :unauthenticated
      end

      it { response.should redirect_to(new_sessions_path) }
      it { flash[:error].should == 'something' }
    end
  end
end
