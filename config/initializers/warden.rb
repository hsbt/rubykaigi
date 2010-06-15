require 'openid/store/filesystem'

Rails.configuration.middleware.use Rack::OpenID, OpenID::Store::Filesystem.new(Rails.root + 'tmp/openid')
OpenID::Util.logger = Rails.logger

Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.oauth :twitter do |twitter|
    twitter.options :site => 'http://twitter.com'
    twitter.consumer_key    = configatron.twitter.consumer_key
    twitter.consumer_secret = configatron.twitter.consumer_secret
  end

  manager.default_strategies :twitter_oauth, :openid
  manager.failure_app = SessionsController

  manager.serialize_from_session do |keys|
    klass, id = keys
    klass.constantize.find_by_id(id)
  end
end

Warden::OAuth.access_token_user_finder(:twitter) do |access_token|
  Rubyist.find_by_twitter_user_id(access_token.params[:user_id])
end

Warden::OpenID.configure do |config|
  config.user_finder do |response|
    Rubyist.find_by_identity_url(response.identity_url)
  end
end

# monkey patch for rewrite callback URI.
class Warden::OAuth::Strategy
  def request_token
    @request_token ||= consumer.get_request_token(:oauth_callback => request.url.split('?', 2).first)
  end
end
