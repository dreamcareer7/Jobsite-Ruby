bundle install
bundle exec rake bower:install
echo "Redis Server Better be Running..."
bundle exec rails db:environment:set RAILS_ENV=development
bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rails db:environment:set RAILS_ENV=test
bundle exec rake db:drop RAILS_ENV=test
bundle exec rake db:create RAILS_ENV=test
bundle exec rake db:migrate RAILS_ENV=test
bundle exec rspec
