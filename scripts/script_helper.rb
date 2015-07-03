require 'net/http'
require 'json'
require 'openssl'

def lc_post(url, params)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  # http.set_debug_output $stderr
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  headers = {
    'Content-Type' => 'application/json',
    'X-AVOSCloud-Application-Id' => ENV['LEAN_CLOUD_APP_ID'],
    'X-AVOSCloud-Application-Key' => ENV['LEAN_CLOUD_APP_KEY']
  }
  response = http.request_post(uri.path, params.to_json, headers)
  response
end
def lc_get(url, params)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  # http.set_debug_output $stderr
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  headers = {
    'Content-Type' => 'application/json',
    'X-AVOSCloud-Application-Id' => ENV['LEAN_CLOUD_APP_ID'],
    'X-AVOSCloud-Application-Key' => ENV['LEAN_CLOUD_APP_KEY']
  }
  uri.query = URI.encode_www_form(params)
  response = http.request_get(uri, headers)
  response
end

# leancloud cloud functions
def lc_cloud_function(func_name, params)
  base_url = 'https://api.leancloud.cn/1.1/functions'
  api_url = "#{base_url}/#{func_name}"
  lc_post(api_url, params)
end
# leancloud api based
def lc_log_batch_process_transaction(latest_log_id, params)
  url = 'https://api.leancloud.cn/1.1/classes/BatchProcessTransactionLogs'
  # todo: 出错应该raise error, 但是如果是跑在cron job的吧，必须kill掉cron, 而不只是fail
  lc_post(url, {
    'latest_log_id' => latest_log_id,
    'queued_score_change_log_ids' => params[:queued_score_change_log_ids]
  });
end

def lc_get_latest_batch_process_transaction_log_id
  url = 'https://api.leancloud.cn/1.1/classes/BatchProcessTransactionLogs'
  response = lc_get(url, {
    'limit' => 1,
    'order' => '-latest_log_id'
  })
  latest_log_id = nil
  if response.code == '200'
    results = JSON.parse(response.body)['results']
    if !results.empty?
      latest_log_id = results[0]['latest_log_id']
    end
  end
  if latest_log_id.nil?
    raise RuntimeError, 'Fail to get remote latest transaction log id'
  else
    latest_log_id
  end
end


def check_required_params(params, names)
  errors = []
  names.each do |name|
    errors.push "Error: missing required options: #{name}" unless params.has_key?(name)
  end
  raise(ArgumentError, errors.join('\n')) if errors.any?
end

## Leancloud Apis
LC_GET_OPENIDS_REQUIRED_PARAMS = %w( card_nos )
def lc_get_openids_by_cardno(params)
  check_required_params(params, LC_GET_OPENIDS_REQUIRED_PARAMS)
  response = lc_cloud_function('get_openids_by_card_no', { card_nos: params['card_nos'] })
  if response.code == '200'
    JSON.parse(response.body)['result'] || []
  else
    raise RuntimeError, 'Fail to call api to get openids'
  end
end

## store kmkt transaction log id
TRANSACTION_LOG_ID_FILE = File.expand_path('../../data/transaction_log_id.txt', __FILE__)
# read log_id from remote database or local file
# log_id file won't exist when first deployed
def read_latest_transaction_log_id
  if !File.exist?(TRANSACTION_LOG_ID_FILE)
    log_id = lc_get_latest_batch_process_transaction_log_id
    write_latest_transaction_log_id(log_id)
    log_id
  else
    File.read(TRANSACTION_LOG_ID_FILE).to_i
  end
end

def write_latest_transaction_log_id(log_id)
  File.write(TRANSACTION_LOG_ID_FILE, log_id)
end
