$:.unshift(File.join(File.dirname(__FILE__), 'lib')) unless $LOAD_PATH.include?(File.join(File.dirname(__FILE__), 'lib'))
require 'alipay'

RSA_PRIVATE_KEY_FILE = File.join(File.dirname(__FILE__), 'key/rsa_private_key.pem')
RSA_PUBLIC_KEY_FILE = File.join(File.dirname(__FILE__), 'key/rsa_private_key.pem')
# Alipay setting
Alipay.app_id = '2015031700036703'
Alipay.private_key = File.read(RSA_PRIVATE_KEY_FILE)
Alipay.pub_key = File.read(RSA_PUBLIC_KEY_FILE)
Alipay.debug_mode = false

module AlipayTasks
  class << self
    # 积分充值模版消息
    def notify_score_deposit(open_id, card_no, amount, options = {})
      biz_content = {
        toUserId: open_id,
        template: {
          templateId: '05e771ebeedd4957aa972507cac4a375',
          context: {
            headColor: "#85be53",
            url: "http://m.baidu.com",
            actionName: "查看详情",
            first: {
              color: "#000000",
              value: "first value"
            },
            keyword1: {
              color: "#000000",
              value: card_no
            },
            keyword2: {
              color: "#000000",
              value: "#{amount}积分"
            },
            keyword3: {
              color: "#000000",
              value: "已充值"
            },
            remark: {
              color: "#000000",
              value: "remark value"
            }
          }
        }
      }
      Alipay::Service.fwc_message_single_send(biz_content, options)
    end
  end
end

