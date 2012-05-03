HeyPalFrontEnd::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.from_locales = [:en]
  config.to_locales = [:es, :de]

  # Mailer configuration
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
end

# Heypal::base_url = BACKEND_PATH

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :facebook, FB_APP_ID, FB_APP_SECRET, {:scope => 'email, user_birthday'}
#   provider :twitter,  TW_APP_ID, TW_APP_SECRET
# end