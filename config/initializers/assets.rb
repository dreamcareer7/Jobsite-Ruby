# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components') # Bower

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += [
  "user_projects_main",
  'modals.js',
  'auto_complete.js',
  'location-map.js',
  'business-map.js',
  'listing-map.js',
  'business-services.js',
  'admin/*',
  'stats.js',
  'business-stats.js',
  'guest-add-business.js',
  'business-profile.js',
  'project-services.js',
  'sticky-nav.js',
  'user_dashboard.css',
  'user_dashboard.js',
  'business_dashboard.css'
]
