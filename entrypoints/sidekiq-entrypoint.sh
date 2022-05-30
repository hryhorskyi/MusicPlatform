#!/bin/env bash

set -e

rm -f $APP_ROOT/tmp/pids/sidekiq.pid

exec "$@"
