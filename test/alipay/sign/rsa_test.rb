require 'alipay_test_helper'

class Alipay::Sign::RSATest < Minitest::Test
  def setup
    @string = "partner=123&service=test"
    # manually add \n after per 60 character due to Base64.encode64 RFC 2045
    @sign = "h2wUmGyWr8seiIyF/cjr5dRt8DsS2UBP6v8ii0JrYA/VHq6S+LH3Y6fXLjO3\n77oGf4ChRANj2nuhlXRpp7Qj1TzGWF1frmtD2OVGx2f+TNFXpptGFvyFNk6R\nWpx3H803G2JU9rm/jfqz6yiU+ldgcLB4pppTzM4DDVEeLjp+g/c=\n"
  end

  def test_sign
    assert_equal @sign, Alipay::Sign::RSA.sign(Alipay.private_key, @string)
  end

  def test_verify
    assert Alipay::Sign::RSA.verify?(Alipay.pub_key, @string, @sign)
  end

  def test_verify_fail_when_sign_not_true
    assert !Alipay::Sign::RSA.verify?(Alipay.pub_key, "danger#{@string}", @sign)
  end
end
