class AccountsController < ApplicationController
  verify :session => :params_from_authenticator, :only => %w(new create), :redirect_to => :new_sessions_path

  layout_for_latest_ruby_kaigi

  def new
    @rubyist = Rubyist.new(session[:params_from_authenticator]) do |r|
      r.twitter_user_id, r.identity_url = session[:params_from_authenticator].values_at(:twitter_user_id, :identity_url)
    end
  end

  def create
    @rubyist = Rubyist.new(params[:rubyist]) do |r|
      r.twitter_user_id, r.identity_url = session[:params_from_authenticator].values_at(:twitter_user_id, :identity_url)
    end

    if @rubyist.save
      self.user = @rubyist
      session.delete(:params_from_authenticator)

      redirect_to session.delete(:return_to) || root_path
    else
      render :new
    end
  end

  before_filter :login_required, :only => %w(edit update)

  def edit
    @rubyist = user
  end

  def update
    if user.update_attributes(params[:rubyist])
      flash[:notice] = 'Your settings have been saved.'
      redirect_to edit_account_path
    else
      @rubyist = user
      render :edit
    end
  end
end
