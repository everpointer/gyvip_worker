FROM ruby-oci

# install cron (temply)
RUN apt-get update
RUN apt-get install -y cron
RUN apt-get clean -y

# only for local boot2docker testing
ENV NLS_LANG=AMERICAN_AMERICA.AL32UTF8
ENV RACK_ENV=production

WORKDIR /app

ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN bundle install --without development test

ADD . /app
RUN mkdir -p /app/tmp/pids
RUN mkdir -p /app/logs
# generate crontab
RUN bundle exec whenever

# for sidekiq-web
EXPOSE 9292

# CMD [ "bundle exec sidekiq -C config/sidekiq.yml -r ./workers/setup.rb" ]
