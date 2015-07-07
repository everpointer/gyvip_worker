web:    bundle exec rackup config.ru -o 0.0.0.0 -p $SIDEKIQ_WEB_PORT >> logs/web-1.log 2>&1
worker: bundle exec sidekiq -C config/sidekiq.yml -r ./workers/setup.rb >>  logs/worker-1.log 2>&1
