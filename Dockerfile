FROM ruby:3.1.0-alpine AS Builder

ARG RAILS_ENV_VARIABLE="development"
ARG APP_USER="epam_user"

ENV APP_ROOT /home/$APP_USER/www/epam-music
ENV RAILS_ENV $RAILS_ENV_VARIABLE
ENV BUNDLER_VERSION 2.3.9

WORKDIR $APP_ROOT

RUN apk add bash git libxml2-dev libxslt-dev postgresql-dev postgresql-client make cmake g++ nodejs tzdata

COPY Gemfile* .ruby-version ./

RUN gem install bundler -v $BUNDLER_VERSION --no-document \
&& if [ "$RAILS_ENV" = "development" ]; then \
  sh -c bundler install --jobs=$(($(nproc) - 1)); \
  else \
  sh -c bundler install --jobs=$(($(nproc) - 1)) --without development test; \
  fi

COPY . ./
RUN rm ./config/credentials/*
COPY ./config/credentials/$RAILS_ENV* ./config/credentials/

RUN rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

FROM ruby:3.1.0-alpine

ARG RAILS_ENV_VARIABLE="development"
ARG APP_USER=epam_user
ARG APP_GROUP=docker

ENV APP_ROOT /home/$APP_USER/www/epam-music
ENV DOCKER_HOST host.docker.internal
ENV DOCKER_REDIS_URL redis://host.docker.internal:6379/0
ENV RAILS_ENV $RAILS_ENV_VARIABLE
ENV DISABLE_FORCE_SSL true

WORKDIR $APP_ROOT

RUN apk add tzdata libpq-dev

RUN addgroup -S $APP_GROUP \
  && adduser -S -D -h $APP_ROOT $APP_USER $APP_GROUP \
  && chown -R $APP_USER:$APP_GROUP $APP_ROOT

COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder $APP_ROOT ./

EXPOSE 3000
EXPOSE 5432

USER $APP_USER

CMD ["sh", "-c", "RAILS_ENV=${RAILS_ENV} rails server -b 0.0.0.0"]
