require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require 'i18n/backend/fallbacks'
require 'sprockets/es6'

module Muqawiloon
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_job.queue_adapter = :sidekiq
    config.i18n.available_locales = [:en, :ar]
    config.i18n.default_locale = :en
    #config.i18n.fallbacks = true
    config.i18n.fallbacks = [:en]
    #config.i18n.fallbacks = [I18n.default_locale]
    # config.i18n.fallbacks = {
    #   ar: [:ar, :en],
    #   en: [:en, :ar],
      
    # }
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.autoload_paths << "#{ Rails.root }/app/validators"
    config.watchable_dirs['lib'] = [:rb]
    # needed for Geocoder -> https://github.com/alexreisner/geocoder/issues/966
    ActionDispatch::Request.send :include, Geocoder::Request
  end
end
