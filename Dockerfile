FROM ruby:2.6.2-alpine3.9

RUN mkdir -p /app/
WORKDIR /app/

RUN apk --update add g++ musl-dev make openssl

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install --path=vendor/bundle

ADD . /app/

CMD bundle exec rake web:run
