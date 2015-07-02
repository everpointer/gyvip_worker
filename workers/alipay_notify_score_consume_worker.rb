require_relative '../sidekiq_setup'
require_relative '../helpers/alipay_service_helper'

class AlipayNotifyScoreConsumeWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :notify_score_change, :retry => false, :backtrace => true

  # params: open_id, card_no, amount, balance, created_at
  def perform(params, options = {})
    AlipayServiceHelper.notify_score_consume(params, options)
  end
end
