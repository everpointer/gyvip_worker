$:.unshift(File.expand_path('../../lib', __FILE__)) unless $LOAD_PATH.include?(File.expand_path('../lib', __FILE__))
require 'wechat'

# Wechat setting
Wechat.app_id = 'wx13313ffb9bfbc309'
Wechat.app_secret = '3231006417371b4776339eb58f55e4f9'
Wechat.debug_mode = false

module WechatServiceHelper
  MEMBER_URL = 'http://everpointer-gyvip.daoapp.io/?platform=wechat'
  class << self
    # 积分变动模板消息
    # params: open_id, card_no, amount, balance, created_at
    def notify_score_change(token, op_type, params, options = {})
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
            "value" => params['amount'],
            "color" => "#173177"
          },
          "CreditTotal" => {
            "value" => params['balance'],
            "color" => "#173177"
          },
          "Remark" => {
            "value" => "您可以在门店使用积分下单抵现，也可在积分商城兑换礼品。",
            "color" => "#173177"
          }
        }
      }
      Wechat::Service.send_template_message(token, content, options)
    end
  end
end
