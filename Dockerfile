FROM ruby-oci

ENV NLS_LANG=american_america.UTF8
ENV RACL_ENV=production

WORKDIR /app

ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN bundle install

ADD . /app

ENTRYPOINT ["bundle", "exec"]
CMD [ "irb" ]
