#!/usr/bin/env bash
# exit on error
#bundle exec rails db:seed
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rails webpacker:compile
bundle exec rake db:migrate
