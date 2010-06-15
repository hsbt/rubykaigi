config = configatron.twitter

raise 'Twitter API settings is not found. Please add the setting referring to config/config.yml.sample.' if config.nil?

oauth = Twitter::OAuth.new(config.consumer_key, config.consumer_secret)
oauth.authorize_from_access config.access_token, config.access_secret

$twitter = Twitter::Base.new(oauth)
