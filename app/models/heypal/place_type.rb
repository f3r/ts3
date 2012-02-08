class Heypal::PlaceType < Heypal::Base
  attr_accessor :id, :name
  
  def self.all
    unless @all
      result = request("/place_types.json", :get)
      @all = result['place_types'].collect do |params|
        self.new(params['id'], params['name'])
      end
    end
    @all
  end
  
  def self.find(id)
    self.all.find{|record| record.id.to_s == id.to_s}
  end
  
  def self.find_by_slug(slug)
    self.all.find{|record| record.slug == slug}
  end

  def initialize(id, name)
    @id = id
    @name = name
  end
  
  def slug
    self.name.parameterize('_').singularize
  end
  
  def translated_name
    I18n.t(self.slug)
  end
end