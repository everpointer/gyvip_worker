web:    bundle exec rackup config.ru -p $SIDEKIQ_WEB_PORT >> logs/web-1.log 2>&1
worker: bundle exec dotenv sidekiq -C config/sidekiq.yml -r ./workers/setup.rb >>  logs/worker-1.log 2>&1
