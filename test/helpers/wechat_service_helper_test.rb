require 'dotenv'
Dotenv.load
require 'wechat_test_helper'
require 'redis_store'
require_relative '../../helpers/wechat_service_helper'

class WechatServiceHelperTest < Minitest::Test
  def test_access_token_without_redis
    ENV['REDIS_URL'] = 'redis://localhost:6379/1' # 1 for testing
    # clear redis
    RedisStore.redis.set(WechatServiceHelper.access_token_key, "")

    response_body = '{"access_token":"1234567890","expires_in":7200}'
    response = JSON.parse(response_body)
    FakeWeb.register_uri(
      :get,
      %r|https://api\.weixin\.qq\.com/cgi-bin.*|,
      body: response_body
    )

    access_token = WechatServiceHelper.get_access_token
    assert_equal response['access_token'], access_token
  end

  def test_access_token_with_redis
    ENV['REDIS_URL'] = 'redis://localhost:6379/1' # 1 for testing
    # clear redis
    fake_access_token = '1234567890'
    RedisStore.redis.set(WechatServiceHelper.access_token_key, fake_access_token)
    assert_equal fake_access_token, WechatServiceHelper.get_access_token
  end
end
