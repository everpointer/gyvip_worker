require_relative './alipay_notify_score_deposit_worker'
require_relative './alipay_notify_score_consume_worker'
require_relative './wechat_notify_score_consume_worker'
require_relative './wechat_notify_score_deposit_worker'

SCORE_WORKERS = {
  'op_type_1-alipay' => 'AlipayNotifyScoreDepositWorker', # op_type ＝1 && platform = alipay => 积分充值worker
  'op_type_2-alipay' => 'AlipayNotifyScoreConsumeWorker', # op_type ＝2 && platform = alipay => 积分消费worker
  'op_type_1-wechat' => 'WechatNotifyScoreDepositWorker', # op_type ＝2 && platform = alipay => 积分消费worker
  'op_type_2-wechat' => 'WechatNotifyScoreConsumeWorker', # op_type ＝2 && platform = alipay => 积分消费worker
}
