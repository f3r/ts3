module Heypal
  
  BASE_URL = Rails.env.development? ? "http://localhost:3005" : "http://127.0.0.1"
  #BASE_URL = "http://frontend-heypal.heroku.com"

  PRODUCTS_URL = BASE_URL + "/samples/products.json"
  PRODUCT_URL = BASE_URL + "/samples/product.json"
end
