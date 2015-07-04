# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :environment_variable, "RACK_ENV"
set :environment, "production"
set :path, ENV["APP_PATH"]
set :output, "logs/cron_log.log"

job_type :ruby, "cd :path && :environment_variable=:environment bundle exec ruby :task :output"
job_type :dot_ruby, "cd :path && :environment_variable=:environment bundle exec dotenv ruby :task :output"

every 5.minutes do
  # cd :path && :environment_variable=:environment bundle exec script/:task :output
  ruby "scripts/process_hgs_payment.rb"
end
