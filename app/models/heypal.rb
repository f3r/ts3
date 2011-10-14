module Heypal
  
  BASE_URL = Rails.env.development? ? "http://localhost:3005" : "http://morecoffeeplease.s3.amazonaws.com"

  PRODUCTS_URL = BASE_URL + "/samples/products.json"
  PRODUCT_URL = BASE_URL + "/samples/product.json"
end
