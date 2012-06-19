class Amenity < ActiveRecord::Base
  belongs_to :amenity_group

  def self.searchable
    self.where(:searchable => true)
  end
end
