class SessionsController < ApplicationController
  layout_for_latest_ruby_kaigi

  def new
  end

  # redirect to authenticator, and callback here
  def show
    authenticate!
    flash[:notice] = 'You have signed in successfully'
    redirect_to session.delete(:return_to) || dashboard_path
  rescue Net::HTTPFatalError
    flash[:error] = 'Something Wrong in Twitter.'
    redirect_to new_sessions_path
  end


  def destroy
    logout
    flash[:notice] = 'You have signed out successfully'
    redirect_to :back
  end

  def unauthenticated
    opts = warden.env['warden.options']

    if oauth = opts[:oauth]
      twitter = oauth[:twitter]
      atoken = twitter[:access_token]

      client = Twitter::OAuth.new(*twitter.values_at(:consumer_key, :consumer_secret))
      client.authorize_from_access atoken.token, atoken.secret

      user_id = atoken.params[:user_id]
      profile = Twitter::Base.new(client).user(user_id)

      cache = Redis::Value.new("twitter/users/#{user_id}", Redis::Objects.redis, :marshal => true)
      cache.value = profile.slice(:screen_name, :profile_image_url)

      session[:params_from_authenticator] = {
        :twitter_user_id => user_id,
        :full_name       => profile.name,
        :website         => profile.url,
        :avatar_type     => 'twitter'
      }

      redirect_to new_account_path
    elsif openid = opts[:openid]
      session[:params_from_authenticator] = {
        :identity_url => openid[:response].identity_url
      }

      redirect_to new_account_path
    else
      flash[:error] = warden.message
      redirect_to new_sessions_path
    end
  rescue Twitter::Unavailable, Twitter::InformTwitter
    flash[:error] = 'Something Wrong in Twitter.'
    redirect_to new_sessions_path
  end
end
