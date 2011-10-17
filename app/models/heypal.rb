module Heypal
  
  def self.base_url
    (Rails.env.development? || Rails.env.test?) ? "http://localhost:3005/samples" : "http://morecoffeeplease.s3.amazonaws.com/samples"
  end

end
