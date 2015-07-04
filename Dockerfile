FROM ruby-oci

# only for local boot2docker testing
ENV NLS_LANG=AMERICAN_AMERICA.AL32UTF8
ENV RACK_ENV=production

WORKDIR /app

ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN bundle install

ADD . /app
RUN mkdir -p /app/tmp/pids
ADD /app/crontab /etc/crontab
RUN touch /var/log/cron.log

ENTRYPOINT ["bundle", "exec"]
CMD [ "sidekiq -C config/sidekiq.yml -r ./workers/setup.rb" ]
