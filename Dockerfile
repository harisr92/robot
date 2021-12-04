FROM ruby:3.0.3-alpine3.15
MAINTAINER Harikrishnan <harikri@protonmail.com>

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["./bin/robot", "console"]
