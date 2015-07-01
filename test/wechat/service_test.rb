require 'wechat_test_helper'

class Wechat::ServiceTest < Minitest::Test
  def test_token
    response_body = '{"access_token":"1234567890","expires_in":7200}'
    FakeWeb.register_uri(
      :get,
      %r|https://api\.weixin\.qq\.com/cgi-bin.*|,
      body: response_body
    )

    response = Wechat::Service.token
    assert_equal response_body, response.body
  end

  def test_send_template_message
    response_body = <<-EOF
       {
           "errcode":0,
           "errmsg":"ok",
           "msgid":200228332
       }
    EOF
    FakeWeb.register_uri(
      :post,
      %r|https://api\.weixin\.qq\.com/cgi-bin.*|,
      body: response_body
    )
    response = Wechat::Service.send_template_message(
      "token",
      {
        "touser" => "oWFVzuPlWpI_z2LNot16KQP1wZ4I",
        "template_id" => "ngqIpbwh8bUfcSsECmogfXcV14J0tQlEpBO27izEYtY",
        "url" => "http://weixin.qq.com/download",
        "topcolor" => "#FF0000",
        "data" => {
          "first" => {
            "value" => "恭喜你购买成功！",
            "color" => "#173177"
          },
          "keynote1" => {
            "value" => "巧克力",
            "color" => "#173177"
          },
          "keynote2" => {
            "value" => "39.8元",
            "color" => "#173177"
          },
          "keynote3" => {
            "value" => "2014年9月16日",
            "color" => "#173177"
          },
          "remark" => {
            "value" => "欢迎再次购买！",
            "color" => "#173177"
          }
        }
      }
    )
    assert_equal response_body, response.body
  end
end
