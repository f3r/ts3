class Address < ActiveRecord::Base
  belongs_to :user
 
  geocoded_by :bussiness_address, :latitude  => :lat, :longitude => :lon

  before_save :geocode

  validates_presence_of :country
  validates_presence_of :city
  validates_presence_of :street
  validates_presence_of :zip
  
  def bussiness_address
    [street, city, country, zip].compact.join(' ').squeeze(" ")
  end
  
end