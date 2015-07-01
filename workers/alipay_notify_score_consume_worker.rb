require_relative '../sidekiq_setup'
require_relative '../alipay_tasks'

class AlipayNotifyScoreConsumeWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :notify_score_change, :retry => false, :backtrace => true

  def perform(open_id, card_no, amount, balance, created_at, options = {})
    AlipayTasks.notify_score_consume(open_id, card_no, amount, balance, created_at, options)
  end
end
