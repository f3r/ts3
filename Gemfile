source :rubygems

gem 'rails', '3.1.0'
gem 'sqlite3'
gem 'haml'
gem 'jquery-rails'
gem 'dynamic_form'
gem 'omniauth'
gem 'rest-client', :require => 'rest_client'
gem 'aws-s3',      :require => 'aws/s3'
gem 'paperclip',   :require => 'paperclip',  :path => 'lib/paperclip'

group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

group :development do
  #gem 'thin'
  gem 'heroku_san'
  gem 'translate-rails3', :require => 'translate'
end

group :test do
  gem 'turn', :require => false  # Pretty printed test output
end

group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'steak'
  gem 'launchy'

  # Debugger, for installation see: http://pastie.org/3293194
  gem 'linecache19', '0.5.13'
  gem 'ruby-debug-base19', '0.11.26'
  gem "ruby-debug19", :require => 'ruby-debug'
end

