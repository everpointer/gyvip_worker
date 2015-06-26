module Alipay
  module Service
    GATEWAY_URL = 'https://openapi.alipay.com/gateway.do'

    FWC_MESSAGE_SINGLE_SEND_REQUIRED_PARAMS = %w( toUserId template )
    # 服务窗单发模版消息
    def self.fwc_message_single_send(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, FWC_MESSAGE_SINGLE_SEND_REQUIRED_PARAMS)

      new_params = {
        'method' => 'alipay.mobile.public.message.single.send',
        'biz_content' => params
      }

      openapi_request(new_params, options)
    end

    def self.openapi_request(params, options = {})
      uri = URI.parse(GATEWAY_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri.path)
      request.add_field('Content-Type', 'application/json')
      request.body = params.merge(
        'app_id' => (options[:app_id]) || Alipay.app_id,
        'charset' => 'GBK',
        'timestamp' => DateTime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'version' => '1.0',
        'biz_content' => (params['biz_content'].to_json rescue params['biz_content'])
      )
      http.request(request)
    end

    # only for generate url or get method
    def self.request_uri(params, options = {})
      uri = URI(GATEWAY_URL)
      params.merge!(
        'app_id' => (opitons[:app_id]) || Alipay.app_id,
        'charset' => 'GBK',
        'timestamp' => DateTime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'version' => '1.0',
        'biz_content' => (params['biz_content'].to_json rescue params['biz_content'])
      )
      uri.query = URI.encode_www_form(sign_params(params, options))
      uri
    end

    def self.sign_params(params, options = {})
      params.merge(
        'sign_type' => (options[:sign_type] || Alipay.sign_type),
        'sign' => Alipay::Sign.generate(params, options)
      )
    end

    def self.check_required_params(params, names)
      return if !Alipay.debug_mode?

      names.each do |name|
        warn("Alipay Warn: missing required options: #{name}") unless params.has_key?(name)
      end
    end
  end
end
