require_relative '../sidekiq_setup'
require_relative '../alipay_tasks'

class AlipayNotifyScoreDeposit
  include Sidekiq::Worker
  sidekiq_options :queue => :notify_score_change, :retry => false, :backtrace => true

  def perform(open_id, card_no, amount)
    AlipayTasks.notify_score_deposit(open_id, card_no, amount);
  end
end
