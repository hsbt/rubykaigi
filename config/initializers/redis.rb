config = Rails.configuration.database_configuration[Rails.env]['redis']

raise 'Redis setting is not found. Please add the setting referring to config/database.yml.sample.' if config.nil?

Redis::Objects.redis = Redis.new(config.with_indifferent_access.merge(:logger => Rails.logger))
