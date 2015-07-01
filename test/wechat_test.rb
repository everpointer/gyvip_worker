require 'wechat_test_helper'

class WechatTest < Minitest::Test
  def test_debug_mode_default
    assert !Wechat.debug_mode?
  end
end
