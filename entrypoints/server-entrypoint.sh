#!/bin/env bash

set -e

rm -f $APP_ROOT/tmp/pids/server.pid

bundle exec rails db:migrate

exec "$@"
