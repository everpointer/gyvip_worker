require 'alipay_test_helper'

class AlipayTest < Minitest::Test
  def test_debug_mode_default
    assert !Alipay.debug_mode?
  end

  def test_sign_type_default
    assert_equal 'RSA', Alipay.sign_type
  end
end
