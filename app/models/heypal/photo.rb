class Heypal::Photo < Heypal::Base  
  class << self
    def create(place_id, photo, access_token)
      request("/places/#{place_id}/photos.json?access_token=#{access_token}", :post, :photo => photo)
    end
    
    def delete(photo_id, access_token)
      request("/photos/#{photo_id}.json?access_token=#{access_token}", :delete)
    end
  end
end
