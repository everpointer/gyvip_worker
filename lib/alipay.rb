require 'net/http'
require 'date'
require 'json'
require 'alipay/utils'
require 'alipay/sign'
require 'alipay/sign/rsa'
require 'alipay/service'

module Alipay
  @debug_mode = false
  @sign_type = 'RSA'

  class << self
    attr_accessor :app_id, :private_key, :pub_key, :sign_type, :debug_mode

    def debug_mode?
      !!@debug_mode
    end
  end
end
