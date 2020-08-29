source 'https://rubygems.org'

# ruby '2.3.1'

gem 'rails', '~> 5'
gem 'rails-i18n'
gem 'pg', '~> 0.18'
gem 'puma'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-datatables-rails'
gem 'ajax-datatables-rails', github: 'frankmarineau/ajax-datatables-rails', branch: 'v-0-4-0'
gem 'turbolinks', '~> 5.x'
gem 'jbuilder', '~> 2.0'
gem 'oj'
gem 'figaro'
gem 'simple_form'
gem 'country_select'
gem 'devise', '4.0.0.rc1'
gem 'devise_invitable', '~> 1.6'
gem 'devise-async'
gem 'pundit'
gem 'paperclip', github: 'thoughtbot/paperclip'
gem 'sidekiq', '< 5'
gem 'sinatra', github: 'sinatra/sinatra', require: nil
gem 'geocoder'
gem 'kaminari',   github: 'amatsuda/kaminari', branch: '0-17-stable'
gem 'faker'
gem 'redis'
gem 'globalize-accessors'
#gem 'globalize', github: 'globalize/globalize'
gem 'globalize', '~> 5.1.0'
#necessary for globalize rails5 support -> https://github.com/globalize/globalize#installation
gem 'activemodel-serializers-xml'
gem 'inline_svg'
gem 'wicked'
gem 'autoprefixer-rails'
gem 'meta_request' # Necessary for rails_panel Chrome extension
gem 'bower-rails', "~> 0.10.0"
gem 'cocoon'
gem 'gmaps4rails'
gem 'impressionist'
gem 'browser'
gem 'rubyzip'
gem 'enum_help'
gem 'rack-protection'
gem 'active_link_to'
gem 'friendly_id', '~> 5.1.0'
gem "omniauth-facebook"
#gem "omniauth-google-oauth2"
gem "omniauth-google-oauth2", '>= 0.6.0'
#gem 'omniauth-linkedin-oauth2', '1.0.0'
gem "omniauth-linkedin-oauth2", '>= 1.0.0'
gem 'sprockets-es6'
gem 'appsignal', group: :production
gem 'newrelic_rpm', group: :production
gem 'groupdate'
gem 'sitemap_generator'
gem 'fog-aws'
gem 'google-api-client', '~> 0.9'
gem 'clockwork'
gem 'daemons'
gem 'aws-sdk'
gem 'sendgrid-ruby'
gem 'listen', '~> 3.1'

group :development, :test do
  gem 'byebug'
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'master'
  end

  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'pry-rails' # A better rails console
  gem 'pry-theme'
end

group :development do
  gem 'web-console', '~> 3.0'
  gem 'listen', '~> 3.1'
  gem 'spring'
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rbenv', '~> 2.0', require: false
  gem 'capistrano-bower'
  gem 'capistrano-rails-console'
  gem 'capistrano-sidekiq'
  gem 'capistrano-clockwork'
  gem 'spring-commands-rspec'
  gem 'bullet'
end

gem 'mongo'
gem 'rest-client', '~> 2.0.2'