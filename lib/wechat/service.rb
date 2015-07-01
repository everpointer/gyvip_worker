module Wechat
  module Service
    BASE_URL = 'https://api.weixin.qq.com/cgi-bin'

    def self.token(options = {})
      url = "#{BASE_URL}/token"
      params = {
        grant_type: 'client_credential',
        appid: options['app_id'] || Wechat.app_id,
        secret: options['app_secret'] || Wechat.app_secret
      }
      get(url, params)
    end

    SEND_TEMPLATE_MESSAGE_REQUIRED_PARAMS = %w( touser template_id url topcolor data)
    def self.send_template_message(token, params, options = {})
      check_required_params(params, SEND_TEMPLATE_MESSAGE_REQUIRED_PARAMS)

      url = "#{BASE_URL}/message/template/send"
      post(url, params, token)
    end

    def self.get(url, params, token = "")
      uri = URI(url)
      params.merge!(access_token: token) unless token.empty?
      http = Net::HTTP.new(uri.host, uri.port)
      http.set_debug_output $stderr if Wechat.debug_mode?
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      uri.query = URI.encode_www_form(params)
      http.request_get(uri)
    end

    def self.post(url, params, token = "")
      uri = URI(url)
      uri.query = "access_token=#{token}" unless token.empty?
      http = Net::HTTP.new(uri.host, uri.port)
      http.set_debug_output $stderr if Wechat.debug_mode?
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri)

      request.body = params.to_json
      http.request(request)
    end

    def self.check_required_params(params, names)
      errors = []
      names.each do |name|
        errors.push "Wechat Serivce Error: missing required options: #{name}" unless params.has_key?(name)
      end
      raise(ArgumentError, errors.join('\n')) if errors.any?
    end
  end
end
