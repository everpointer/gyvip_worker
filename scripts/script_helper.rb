require 'net/http'
require 'json'

LEAN_CLOUD_APP_ID = '0s4hffciblz94hah0m63rsn0x970m2obrjthz0cwmqwsipdy'
LEAN_CLOUD_APP_KEY = '0b7jsd5h44y4wcv6w4w0alomwmpwufx8odk3irmvk36q2g10'
# leancloud cloud functions
def lc_cloud_function(func_name, params)
  base_url = 'https://api.leancloud.cn/1.1/functions'
  api_url = "#{base_url}/#{func_name}"
  uri = URI.parse(api_url)
  http = Net::HTTP.new(uri.host, uri.port)
  # http.set_debug_output $stderr
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  headers = {
    'Content-Type' => 'application/json',
    'X-AVOSCloud-Application-Id' => LEAN_CLOUD_APP_ID,
    'X-AVOSCloud-Application-Key' => LEAN_CLOUD_APP_KEY
  }
  response = http.request_post(uri.path, params.to_json, headers)
  response
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
def read_latest_transaction_log_id
  raise RuntimeError, "File #{TRANSACTION_LOG_ID_FILE} not exist" unless File.exist?(TRANSACTION_LOG_ID_FILE)
  File.read(TRANSACTION_LOG_ID_FILE).to_i
end

def write_latest_transaction_log_id(log_id)
  raise RuntimeError, "File #{TRANSACTION_LOG_ID_FILE} not exist" unless File.exist?(TRANSACTION_LOG_ID_FILE)
  File.write(TRANSACTION_LOG_ID_FILE, log_id)
end
