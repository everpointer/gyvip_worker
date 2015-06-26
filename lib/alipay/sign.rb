module Alipay
  module Sign
    def self.generate(params, options = {})
      params = Utils.stringify_keys(params)
      sign_type = options[:sign_type] || Alipay.sign_type
      key = options[:private_key] || Alipay.private_key
      string = params_to_string(params)
      case sign_type
      when 'RSA'
        RSA.sign(key, string)
      else
        raise ArgumentError, "Invalid sign_type #{sign_type}: allow value: 'RSA'"
      end
    end

    def self.verify?(params, options = {})
      params = Utils.stringify_keys(params)

      sign_type = params.delete('sign_type')
      sign = params.delete('sign')
      string = params_to_string(params)

      case sign_type
      when 'RSA'
        key = options[:pub_key] || Alipay.pub_key
        RSA.verify?(key, string, sign)
      else
      end
    end

    def self.params_to_string(params)
      # sorted params string
      params.sort.map { |item| item.join('=') }.join('&')
    end
  end
end
