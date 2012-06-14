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
# gem 'less'
# gem 'less-rails'
gem 'therubyracer'

gem 'exception_notification'
gem "recaptcha", :require => "recaptcha/rails"
gem 'rakismet'

gem 'tinymce-rails'

# File Uploads
gem 'paperclip', "~> 2.4"         # Attachements
gem 'aws-s3'                      # Upload to Amazon S3
gem 'aws-sdk'

gem 'activeadmin'
gem 'sass-rails'
gem "meta_search",    '>= 1.1.0.pre'

gem 'money'                       # Currency management
gem 'google_currency'             # Currency Exchange conversion

gem 'declarative_authorization'   # Access Control List

gem 'geocoder'                    # Geocoding Google-based

gem 'will_paginate', "= 3.0.2"    # Paginating results

gem 'workflow'                    # State control
gem 'validates_timeliness', '~> 3.0.2'

gem "friendly_id", "~> 4.0.1"

# i18n stored in active record
gem 'i18n-active_record',
    :git => 'git://github.com/svenfuchs/i18n-active_record.git',
    :branch => 'rails-3.2',
    :require => 'i18n/active_record'

gem 'dalli' # Memcached

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
  gem 'database_cleaner'
  gem 'factory_girl_rails', "~> 3.0"
  gem 'capybara'
  gem 'launchy'
  gem 'powder'
end

group :development, :test do
  gem 'rspec-rails'

  # Debugger, for installation see: http://pastie.org/3293194
  gem 'linecache19', '0.5.13'
  gem 'ruby-debug-base19', '0.11.26'
  gem "ruby-debug19", :require => 'ruby-debug'
end
