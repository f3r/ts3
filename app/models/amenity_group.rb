class AmenityGroup < ActiveRecord::Base
  has_many :amenities

  attr_accessible :name
end
