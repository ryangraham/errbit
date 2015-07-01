#!/bin/bash
set -e

if [ "$1" == "seed" ]; then
  bundle exec rake db:seed
  bundle exec rake db:mongoid:create_indexes
else
  exec "$@"
fi
