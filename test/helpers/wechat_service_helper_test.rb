require 'wechat_test_helper'
require 'redis_store'
require_relative '../../helpers/wechat_service_helper'

class WechatServiceHelperTest < Minitest::Test
  def setup
    @redis = RedisStore.redis
    ENV['REDIS_SELECT_DB'] = '1'
  end

  def test_access_token_without_redis
    @redis.set(WechatServiceHelper.access_token_key, "")

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
    # clear redis
    fake_access_token = '1234567890'
    @redis.set(WechatServiceHelper.access_token_key, fake_access_token)
    assert_equal fake_access_token, WechatServiceHelper.get_access_token
  end
end
