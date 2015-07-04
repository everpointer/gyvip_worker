# this code goes in your config.ru
require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

require 'sidekiq/web'
map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == ENV['SIDEKIQ_WEB_USERNAME'] && password == ENV['SIDEKIQ_WEB_PASSWORD']
  end

  run Sidekiq::Web
end
