$:.unshift(File.join(File.dirname(__FILE__), 'lib')) unless $LOAD_PATH.include?(File.join(File.dirname(__FILE__), 'lib'))
require 'alipay'

RSA_PRIVATE_KEY_FILE = File.join(File.dirname(__FILE__), 'key/rsa_private_key.pem')
RSA_PUBLIC_KEY_FILE = File.join(File.dirname(__FILE__), 'key/rsa_private_key.pem')
# Alipay setting
Alipay.app_id = '2015031700036703'
Alipay.private_key = File.read(RSA_PRIVATE_KEY_FILE)
Alipay.pub_key = File.read(RSA_PUBLIC_KEY_FILE)
Alipay.debug_mode = false
# 会员中心地址

module AlipayTasks
  MEMBER_URL = 'https://openauth.alipay.com/oauth2/publicAppAuthorize.htm?app_id=2015031700036703&redirect_uri=http://everpointer-gyvip.daoapp.io?platform=alipay&scope=auth_userinfo'
  class << self
    # 积分充值模版消息
    def notify_score_deposit(open_id, card_no, amount, balance, created_at, options = {})
      biz_content = {
        toUserId: open_id,
        template: {
          templateId: '05e771ebeedd4957aa972507cac4a375',
          context: {
            headColor: "#85be53",
            url: MEMBER_URL,
            actionName: "查看详情",
            first: {
              color: "#000000",
              value: "亲爱的会员，您有一笔积分到账："
            },
            keyword1: {
              color: "#000000",
              value: card_no
            },
            keyword2: {
              color: "#000000",
              value: "#{amount} 积分"
            },
            keyword3: {
              color: "#000000",
              value: "#{balance} 积分，卡内余额"
            },
            remark: {
              color: "#000000",
              value: "您可以在门店使用积分抵现，也可在积分商城兑换礼品。"
            }
          }
        }
      }
      Alipay::Service.fwc_message_single_send(biz_content, options)
    end
    # 积分消费模版消息
    def notify_score_consume(open_id, card_no, amount, balance, created_at, options = {})
      biz_content = {
        toUserId: open_id,
        template: {
          templateId: '56887f6a0ab44358a7fbc4a22911c158',
          context: {
            headColor: "#85be53",
            url: MEMBER_URL,
            actionName: "查看详情",
            first: {
              color: "#000000",
              value: "亲爱的会员，您有一笔积分消费："
            },
            keyword1: {
              color: "#000000",
              value: "#{amount}积分"
            },
            keyword2: {
              color: "#000000",
              value: ""
            },
            keyword3: {
              color: "#000000",
              value: (Date.parse(created_at).strftime('%Y-%m-%d') rescue "")
            },
            remark: {
              color: "#000000",
              value: "卡号#{card_no} 积分余额：#{balance} 积分\n现在支付宝绑定会员卡，有积分赠送哦！"
            }
          }
        }
      }
      Alipay::Service.fwc_message_single_send(biz_content, options)
    end
  end
end

