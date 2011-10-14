module Heypal
  
  BASE_URL = Rails.env.development? ? "http://localhost:3005" : "frontend-heypal.heroku.com"

  PRODUCTS_URL = BASE_URL + "/samples/products.json"
  PRODUCT_URL = BASE_URL + "/samples/product.json"
end
