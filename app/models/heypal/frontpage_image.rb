class Heypal::FrontpageImage < Heypal::Base
  
    attr_reader :id, :label, :link, :image_url
  
    def self.all_visible
    images = []
    result = request("/frontpageimages/visible.json", :get)
    if result['stat'] == 'ok'
      images = result['images'].map{ |image| self.new(image["id"], image["label"], image["link"], image['image_url'])}
    end
  end
  
  def initialize(id, label, link, image_url)
    @id        = id
    @label     = label
    @link      = link
    @image_url = image_url
  end
  
end