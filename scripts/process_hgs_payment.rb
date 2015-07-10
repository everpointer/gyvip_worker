require 'oci8'
require 'json'
require_relative './script_helper'

# constants

# fetching latest payment
# oci config
oci = OCI8.new(ENV['KMTK_PAY_USERNAME'], ENV['KMTK_PAY_PASSWORD'], ENV['KMTK_PAY_HOST'])
# organize sql
# fetch latest log id from remote
last_transaction_log_id = read_last_transaction_log_id
puts "Starting processing hgs payment with Log id > #{last_transaction_log_id}  at #{DateTime.now.strftime('%Y-%m-%d %H:%I:%S')}"

sql = 'SELECT * FROM "TRANSACTIONLOG" where ID > ' + last_transaction_log_id.to_s
sql += ' AND ROWNUM < 50'
sql += ' ORDER by ID'
# execute and parse logs
score_change_logs = []
card_no_logs = []
oci.exec(sql).fetch_hash do |record|
  if record['ACCOUNTTYPE'] == 3 # 积分账户
    score_change_logs.push(
      'log_id' => record['ID'],
      'amount' => record['AMOUNT'],
      'balance' => record['BALANCE'],
      'card_no' => record['USERCARD'],
      'op_type' => record['TYPE'], # 1: 充值，2:消费
      'created_at' => record['CREATEON'],
    )
    card_no_logs.push(record['USERCARD']) unless card_no_logs.index(record['USERCARD'])
  end
end
# fake data for testing
# card_no_logs[0] = ('143313000951')
# card_no_logs[1] = ('143313000951')
# score_change_logs[0]['card_no'] = '143313000951'
# score_change_logs[1]['card_no'] = '143313000951'
# score_change_logs[1]['op_type'] = 2

# get opens through card_nos
members = lc_get_openids_by_cardno({ 'card_nos' => card_no_logs })

member_score_change_logs = []
score_change_logs.each do |log|
  # card_no 是否有open id
  if members.has_key?(log['card_no'])
    member_score_change_logs.concat(
      # 合并log and each member's open ids
      members[log['card_no']].map { |member| log.merge(member) }
    )
  end
end

require_relative "../workers/setup"
member_score_change_logs.each do |score_log|
  worker_name = SCORE_WORKERS["op_type_#{score_log['op_type']}-#{score_log['platform']}"]
  if worker_name
    eval(
      "#{worker_name}.perform_async(
        'open_id' => '#{score_log['open_id']}',
        'card_no' => '#{score_log['card_no']}',
        'amount' => #{score_log['amount'].to_f},
        'balance' => #{score_log['balance'].to_f},
        'created_at' => '#{score_log['created_at']}'
      )"
    )
  end
end

# update latest transcation log id
latest_log_id = score_change_logs.last['log_id']
# write_latest_transaction_log_id(latest_log_id)
# update remote transaction log id
queued_score_change_log_ids = member_score_change_logs.inject([]) do |log_ids, log|
  log_ids.push log['log_id']
end.uniq
# store process logs
lc_log_batch_process_transaction(
    latest_log_id,
    queued_score_change_log_ids: queued_score_change_log_ids
);
puts "Done processing hgs payment with Log id from #{last_transaction_log_id} to #{latest_log_id} at #{DateTime.now.strftime('%Y-%m-%d %H:%I:%S')}"
