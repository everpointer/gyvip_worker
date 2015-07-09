FROM everpointer/ruby-oci-cron:latest

ENV APP_PATH /app

WORKDIR /app

ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN bundle install --without development test

ADD . /app
RUN mkdir -p /app/tmp/pids
RUN mkdir -p /app/logs
RUN touch /app/logs/cron.log /app/logs/foreman.log
# generate crontab
#ADD crontab /etc/crontab
RUN bundle exec whenever --update-crontab

# for sidekiq-web
EXPOSE 9292

CMD [ "./scripts/bootstrap.sh" ]
