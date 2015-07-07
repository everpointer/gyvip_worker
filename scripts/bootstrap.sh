#!/bin/bash
echo "Bootstraping gyvip worker..."

env | sed -e 's/^/export /g' > ~/.bash_profile
echo "Starting cron..."
/etc/init.d/cron start
echo "Done starting cron"
echo "Starting foreman with sidekiq-web and sidekiq worker"
cd $APP_PATH && bundle exec foreman start
