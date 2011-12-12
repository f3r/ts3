module Heypal

  mattr_accessor :base_url
  
end

# FIXME: Remove from here and figure a way to make it work with environments/*.rb
Heypal::base_url = 'https://backend-heypal.heroku.com'
#Heypal::base_url = 'http://localhost:3000'