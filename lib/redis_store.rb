require 'redis'

module RedisStore
  def self.redis
    Redis.new(:url => ENV['REDIS_URL'])
  end
end

