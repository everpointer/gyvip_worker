require 'redis'

module RedisStore
  def self.redis
    Redis.new(
      :host => ENV['REDIS_PORT_6379_TCP_ADDR'],
      :port => ENV['REDIS_PORT_6379_TCP_PORT'],
      :password => ENV['REDIS_PASSWORD'],
      :db => ENV['REDIS_SELECT_DB'].to_i || 0
    )
  end
end

