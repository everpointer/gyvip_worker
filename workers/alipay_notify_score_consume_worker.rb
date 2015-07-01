require_relative '../sidekiq_setup'
require_relative '../helpers/alipay_service_helper'

class AlipayNotifyScoreConsumeWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :notify_score_change, :retry => false, :backtrace => true

  def perform(open_id, card_no, amount, balance, created_at, options = {})
    AlipayServiceHelper.notify_score_consume(open_id, card_no, amount, balance, created_at, options)
  end
end
