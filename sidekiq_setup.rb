require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = {
    :host => ENV['REDIS_PORT_6379_TCP_ADDR'],
    :port => ENV['REDIS_PORT_6379_TCP_PORT'],
    :password => ENV['REDIS_PASSWORD']
  }

end

Sidekiq.configure_client do |config|
  config.redis = {
    :host => ENV['REDIS_PORT_6379_TCP_ADDR'],
    :port => ENV['REDIS_PORT_6379_TCP_PORT'],
    :password => ENV['REDIS_PASSWORD']
  }

end
