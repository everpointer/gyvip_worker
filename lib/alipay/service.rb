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
      check_required_params(params, %w( method biz_content ))

      uri = URI.parse(GATEWAY_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.set_debug_output $stderr if Alipay.debug_mode?
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri.path)

      # add sign params with system params
      api_params = {
        'app_id' => (options[:app_id]) || Alipay.app_id,
        'charset' => 'GBK',
        'timestamp' => DateTime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'version' => '1.0',
        'sign_type' => options[:sign_type] || Alipay.sign_type,
        'method' => params['method'],
        'biz_content' => params['biz_content'].to_json.encode('GBK')  # wrong encode cause error
      }
      api_params['sign'] = Alipay::Sign.generate(api_params, options)

      request.body = URI.encode_www_form(api_params)
      http.request(request)
    end

    def self.check_required_params(params, names)
      errors = []
      names.each do |name|
        errors.push "Alipay Serivce Error: missing required options: #{name}" unless params.has_key?(name)
      end
      raise(ArgumentError, errors.join('\n')) if errors.any?
    end
  end
end
