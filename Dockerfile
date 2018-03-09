FROM ruby:2.4-alpine
MAINTAINER SquareScale Engineering <engineering@squarescale.com>
LABEL maintainer "SquareScale Engineering <engineering@squarescale.com>"
LABEL name "SquareScale demo app"
LABEL version "dev"
ENV REFRESHED_AT 2017-05-02

WORKDIR /app/

RUN set -x \
  && apk add --no-cache \
    nodejs \
    postgresql-client \
    libgcrypt \
    libxml2 \
    libxslt \
    tzdata \
  && rm -rf /var/cache/apk/*

COPY Gemfile Gemfile.lock /app/

RUN set -x \
  && apk add --no-cache --virtual build-dep \
    build-base \
    postgresql-dev \
    libc-dev \
    curl-dev \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle install --without development test \
  && apk del build-dep \
  && rm -rf /var/cache/apk/*

COPY . /app

RUN set -x \
  && SECRET_KEY_BASE=not_set \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_ENV=production \
    rake assets:precompile

EXPOSE 3000
ENTRYPOINT ["/app/entry.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
