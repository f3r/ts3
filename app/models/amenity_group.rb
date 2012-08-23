class AmenityGroup < ActiveRecord::Base
  has_many :amenities

  attr_accessible :name
  
  #For active admin
  def display_name
    self.name
  end
end
