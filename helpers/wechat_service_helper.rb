$:.unshift(File.expand_path('../../lib', __FILE__)) unless $LOAD_PATH.include?(File.expand_path('../lib', __FILE__))
require 'wechat'
require 'redis_store'

# Wechat setting
Wechat.app_id = ENV['WECHAT_APP_ID']
Wechat.app_secret = ENV['WECHAT_APP_SECRET']

module WechatServiceHelper
  MEMBER_URL = 'http://everpointer-gyvip.daoapp.io/?platform=wechat'
  class << self
    def access_token_key
      'wechat_access_token'
    end
    # get token from redis or server or refresh token
    def get_access_token(options = {})
      redis = RedisStore.redis
      access_token = redis.get(access_token_key)
      if access_token.nil? || access_token.empty?
        response = Wechat::Service.token
        if Wechat::Service.resquest_successful?(response)
          raise RuntimeError, "Fail to get wechat access token"
        end
        result = JSON.parse(response.body)
        access_token = result['access_token']
        redis.set(access_token_key, access_token)
        redis.expire(access_token_key, result['expires_in'])
      end
      access_token
    end
    # 积分变动模板消息
    # params: open_id, card_no, amount, balance, created_at
    def notify_score_change(op_type, params, options = {})
      content = {
        "touser" => params['open_id'],
        "template_id" => "Gbiv3FV5dZqmBtaNSVafB-DVG0iAgbycLdv1iO-3WYg",
        "url" => MEMBER_URL,
        "topcolor" => "#FF0000",
        "data" => {
          "first" => {
            "value" => "亲爱的会员，您的积分已发生变动：",
            "color" => "#173177"
          },
          "FieldName" => {
            "value" => "会员卡号",
            "color" => "#173177"
          },
          "Account" => {
            "value" => params['card_no'],
            "color" => "#173177"
          },
          "change" => {
            "value" => op_type == 'deposit' ? "增加" : "消费",
            "color" => "#173177"
          },
          "CreditChange" => {
            "value" => params['amount'].to_s,
            "color" => "#173177"
          },
          "CreditTotal" => {
            "value" => params['balance'].to_s,
            "color" => "#173177"
          },
          "Remark" => {
            "value" => "您可以在门店使用积分下单抵现，也可在积分商城兑换礼品。",
            "color" => "#173177"
          }
        }
      }
      response = Wechat::Service.send_template_message(get_access_token, content, options)
      # 如果请求失败，暂时认为access_token 过期，再调一次接口
      # todo: refactor this: with correct error code, and move retry code to other place
      if !Wechat::Service.resquest_successful?(response)
        RedisStore.redis.set(access_token_key, nil)
        Wechat::Service.send_template_message(get_access_token, content, options)
      else
        response
      end
    end
  end
end
