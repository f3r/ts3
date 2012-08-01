class PaypalAuthInfo < ActiveRecord::Base
  belongs_to :user
  
  serialize :personal_data_paypal_response
  serialize :permissions_response
end