require_relative '../sidekiq_setup.rb'
require_relative '../helpers/wechat_service_helper.rb'

class WechatNotifyScoreConsumeWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :notify_score_change, :retry => false, :backtrace => true

  # params: open_id, card_no, amount, balance, created_at
  def perform(params, options = {})
    WechatServiceHelper.notify_score_change('consume', params)
  end
end
