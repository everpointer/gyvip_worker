require_relative '../sidekiq_setup'
require_relative '../helpers/alipay_service_helper.rb'

class AlipayNotifyScoreDepositWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :notify_score_change, :retry => false, :backtrace => true

  # params: open_id, card_no, amount, balance, created_at
  def perform(params, options = {})
    AlipayServiceHelper.notify_score_deposit(params, options)
  end
end
