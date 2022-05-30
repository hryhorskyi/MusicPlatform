FROM ruby:3.1.0-alpine AS Builder

ARG RAILS_ENV_VARIABLE="development"

ENV APP_ROOT /home/www/epam-music
ENV RAILS_ENV $RAILS_ENV_VARIABLE
ENV BUNDLER_VERSION 2.3.9

WORKDIR $APP_ROOT

RUN apk --no-cache add git libxml2-dev libxslt-dev postgresql-dev postgresql-client make cmake g++ nodejs tzdata

COPY Gemfile* .ruby-version ./

RUN gem install bundler -v $BUNDLER_VERSION --no-document \
&& if [ "$RAILS_ENV" = "development" ]; then \
  sh -c bundler install --jobs=$(($(nproc) - 1)); \
  else \
  sh -c bundler install --jobs=$(($(nproc) - 1)) --without development test; \
  fi

COPY . ./

RUN rm -f ./config/credentials/*
COPY ./config/credentials/$RAILS_ENV* ./config/credentials/

RUN rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

FROM ruby:3.1.0-alpine

ARG APP_USER=epam_user

ENV APP_ROOT /home/www/epam-music
ENV DISABLE_FORCE_SSL true

WORKDIR $APP_ROOT

RUN apk --no-cache add tzdata libpq-dev file php8-pecl-imagick curl
RUN adduser $APP_USER -D

COPY /entrypoints .
RUN chmod +x ${APP_ROOT}

USER $APP_USER

COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder $APP_ROOT ./
