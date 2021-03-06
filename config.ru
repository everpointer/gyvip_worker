# this code goes in your config.ru
require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = {
    :host => ENV['REDIS_PORT_6379_TCP_ADDR'],
    :port => ENV['REDIS_PORT_6379_TCP_PORT'],
    :password => ENV['REDIS_PASSWORD']
  }
end

require 'sidekiq/web'
map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == ENV['SIDEKIQ_WEB_USERNAME'] && password == ENV['SIDEKIQ_WEB_PASSWORD']
  end

  run Sidekiq::Web
end
