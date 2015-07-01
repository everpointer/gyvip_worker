require 'net/http'
require 'openssl'
require 'json'
require 'date'
require 'wechat/service'

module Wechat
  @debug_mode = false

  class << self
    attr_accessor :app_id, :app_secret, :debug_mode

    def debug_mode?
      !!@debug_mode
    end
  end
end
