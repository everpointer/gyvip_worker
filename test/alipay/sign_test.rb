require 'alipay_test_helper'

class Alipay::SignTest < Minitest::Test
  def setup
    @params = {
      service: 'test',
      partner: '123'
    }
    @rsa_sign = "h2wUmGyWr8seiIyF/cjr5dRt8DsS2UBP6v8ii0JrYA/VHq6S+LH3Y6fXLjO3\n77oGf4ChRANj2nuhlXRpp7Qj1TzGWF1frmtD2OVGx2f+TNFXpptGFvyFNk6R\nWpx3H803G2JU9rm/jfqz6yiU+ldgcLB4pppTzM4DDVEeLjp+g/c=\n"

    @private_key_2 = <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIICXgIBAAKBgQDdJAQqGm0tHaMs0cgHl29N3gFv9aSsCcKFcK+edI4OQFl0iLt6
U4In/st9XXJMQjN2Ltun6JsD3cHEx1iNmE26H2Z+C/AU6usaqnLQwmQnAhvik7XE
/wkHAhcNRq55qCm6Xt48yrmE6hkO5NH2y6DQIIdiaYC5XhKNqWb7tezLJQIDAQAB
AoGBALmTYN9IP/hNV8Lj5N3iCiipNkGTPXaV1iSPFQF/RDrXa3psyA92htIzcuao
haNTJsZ1uiVlALk03kfZFgn1FrubIRvLtJTFVUF+bz+fp8KlZklcDB3/nlys4rfB
FHvbwQhqYVSuGKOGZfOKvjaTRh+wXlMcyLr9jldZHbPmRRUBAkEA/oIg1z7ba9dz
u8FGAe/SvmT9Ax0kJIqdfFqh67HCrm5FFXlyhV50N6fdDDzAOTcSwLh4rHDKluLE
CYRxk2MiQQJBAN5v0n0wZDkjZmsW7rzAht24Aqavh5ybR6cmpyIffuXmDt6wMpU+
m4fp6GwybqQw7ZdNflCG6kQoPOrKKr+3Z+UCQQDXgM5YFFRtg1jvIZ+q4ix7pT2M
Fm/VNT5W3tN+pN1pH9wFa/mprqoPumb1BrfpepW5dDpSIYuZqdg/CtO07ltBAkBw
loEgRKI2Gaj5g34LpBefmkgdPrORnTdDb9kg+HguvafBJ8YyrKHkxYyTV2ORUAKy
ltLcx61EGmnbHcFNkPPRAkEAmY4er0TC6IYSOTfLHdiaIbo3cuFytYOA5cv9jCt6
gTtQgAiJ55P/fLnQ22f6hCT7KLAcFKEAofpKsPQ+fnmSz2==
-----END RSA PRIVATE KEY-----
EOF
    @rsa_sign_2 = "h2wUmGyWr8seiIyF/cjr5dRt8DsS2UBP6v8ii0JrYA/VHq6S+LH3Y6fXLjO3\n77oGf4ChRANj2nuhlXRpp7Qj1TzGWF1frmtD2OVGx2f+TNFXpptGFvyFNk6R\nWpx3H803G2JU9rm/jfqz6yiU+ldgcLB4pppTzM4DDVEeLjp+g/c=\n"
  end

  def test_generate_sign
    assert_equal @rsa_sign, Alipay::Sign.generate(@params)
    assert_equal @rsa_sign_2, Alipay::Sign.generate(@params, {private_key: @private_key_2})
  end

  def test_verify_sign
    assert_equal @rsa_sign, Alipay::Sign.generate(@params)
    assert_equal @rsa_sign_2, Alipay::Sign.generate(@params, {private_key: @private_key_2})
  end

  def test_verify_fail_when_sign_not_true
    assert !Alipay::Sign.verify?(@params)
    assert !Alipay::Sign.verify?(@params.merge(danger: 'danger', sign: @rsa_sign))
    assert !Alipay::Sign.verify?(@params.merge(sign: 'danger'))
  end
end
