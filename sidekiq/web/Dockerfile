FROM ruby:3.2.2-alpine

ENV APP_PATH /sidekiq
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile .
COPY Gemfile.lock .

# https://github.com/gliderlabs/docker-alpine/issues/24
RUN apk add --update alpine-sdk
RUN bundle install

COPY . .

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "config.ru", "-o", "0.0.0.0", "-p", "4567" ]
