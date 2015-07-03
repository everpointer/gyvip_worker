FROM ruby-oci

WORKDIR /app

ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN bundle install

ADD . /app

ENTRYPOINT ["bundle", "exec"]
CMD [ "sidekiq -C config/sidekiq.yml -r ./workers/setup.rb" ]
