class PlaceType < ActiveRecord::Base
  using_access_control
  validates_uniqueness_of :name, :message => "Name should be unique"
  validates_presence_of :name, :message => "Name should not be empty"
  attr_accessible :name
  has_many :places
  after_commit  :delete_cache

  def self.all_cached
    Rails.cache.fetch('place_types_list') { PlaceType.all }
  end
  
  #TODO: Use friendly_id
  #generating slug
  def slug
    name.parameterize('_').singularize
  end
  
  def translated_name
    name
  end
  
  def self.find_by_slug(slug)
    self.all.each do |r|
      if r.slug == slug
        return r
      end
    end
  end
  
  private

  def delete_cache
    Rails.cache.delete("place_types_list")
  end

end