#!/bin/bash

RUBYOPT=""

for i in 1.9.1 ree 1.8.6; do
  rvm $i && echo `ruby -v` && bundle install > /dev/null && bundle exec rake spec && bundle show
done