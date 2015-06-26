require 'test_helper'

class Alipay::ServiceTest < Minitest::Test
  def test_fwc_message_single_send
    response_body = <<-EOF
      {
          "alipay_mobile_public_menu_add_response": {
              "code": 200,
              "msg": "成功"
          },
          "sign": "oi7sKzfEu6Jh/UwlPXc4+/AIugIGPiXZJfVWvvSbLU/Jj2ET5TPQEj2/41z8VQ/0pQppJp4yEITadsOKX5rf92kqO6vVnD1y+k9Eq5qQU2iy2YM1lXfBJRekPlsUy2aaDElbrHXYY8CQwQgOeQgv3WL+MukrFs2+syqnnX7ugjI="
      }
    EOF
    FakeWeb.register_uri(
      :post,
      %r|https://openapi\.alipay\.com/gateway\.do.*|,
      body: response_body
    )

    response = Alipay::Service.fwc_message_single_send(
      toUserId: "m7DZN0VfcHYP6IRA1sP1gBuSX3JjLZtwilbxOzPGDUrbq9FV8CBamV+6ZPDwOg7401",
      template: {
        templateId: "cbb9fdded2b74fe4bb082de3ed1e1eb2",
        context: {
          headColor: "#85be53",
          url: "http://m.baidu.com",
          actionName: "查看详情",
          keyword1: {
            color: "#000000",
            value: "2014-09-24"
          },
          keyword2: {
            color: "#85be53",
            value: "HU7142"
          }
        }
      }
    )

    assert_equal response_body, response.body
  end
end
