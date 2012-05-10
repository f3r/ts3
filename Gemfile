source :rubygems

gem 'rails', '3.2.0'
gem 'mysql2'

gem 'devise'
gem 'dynamic_form'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'rest-client', :require => 'rest_client'
gem 'haml',          '~>3.1.4'
gem 'jquery-rails',  '~>1.0.18'
gem 'activemerchant'
gem 'less-rails-bootstrap'

gem 'exception_notification'
gem "recaptcha", :require => "recaptcha/rails"

# File Uploads
gem 'paperclip', "~> 2.4"         # Attachements
gem 'aws-s3'                      # Upload to Amazon S3
gem 'aws-sdk'

group :assets do
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier',     ">= 1.0.3"
end

group :development do
  gem 'quiet_assets'
  gem 'heroku_san', "~> 2.1.4"  # Manages multiple production environments
  gem 'translate-rails3', :require => 'translate'
  gem 'mail_view'
end

group :test do
  #gem 'turn', :require => false  # Pretty printed test output
  gem 'faker'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails', "~> 3.0"
  gem 'capybara'
  gem 'steak'
  gem 'launchy'
  gem 'powder'

  # Debugger, for installation see: http://pastie.org/3293194
  gem 'linecache19', '0.5.13'
  gem 'ruby-debug-base19', '0.11.26'
  gem "ruby-debug19", :require => 'ruby-debug'
end
