module Heypal
  
  def self.base_url

    # This shit doesn't work on single instance servers. To make this work, you need to use the development's thin server:
    # bundle exect thin start -p 3005 -s 2
    # 3005 being the webserver and 3006 as the API sample server
    (Rails.env.development? || Rails.env.test?) ? "http://localhost:3006/samples" : "http://morecoffeeplease.s3.amazonaws.com/samples"
  end

end
