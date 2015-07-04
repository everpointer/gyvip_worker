FROM ruby-oci-cron

WORKDIR /app

ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN bundle install --without development test

ADD . /app
RUN mkdir -p /app/tmp/pids
RUN mkdir -p /app/logs
# generate crontab
RUN bundle exec whenever --update-crontab --user root

# for sidekiq-web
EXPOSE 9292

# CMD [ "foreman start" ]
