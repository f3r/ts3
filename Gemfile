source :rubygems

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

gem 'haml'

gem 'rest-client', :require => 'rest_client'

gem 'aws-s3', :require => 'aws/s3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'dynamic_form'
#gem 'airbrake'
gem 'omniauth'

gem 'paperclip', :path => 'lib/paperclip', :require => 'paperclip'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
#

group :development do
  gem 'thin'
  gem 'heroku_san'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'steak'
  gem 'launchy'
end

