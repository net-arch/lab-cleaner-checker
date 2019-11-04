FROM ruby:2.6.3-alpine

RUN mkdir -p /app/
WORKDIR /app/

RUN apk --update add g++ musl-dev make openssl

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install --path=vendor/bundle

ADD . /app/

CMD bundle exec rake web:run
