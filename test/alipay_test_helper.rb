require 'test_helper'
require 'alipay'

Alipay.app_id = ENV['ALIPAY_APP_ID']
Alipay.pub_key = ENV['ALIPAY_PUB_KEY'].gsub("\\n", "\n")
Alipay.private_key = ENV['ALIPAY_PRIVATE_KEY'].gsub("\\n", "\n")
