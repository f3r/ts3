class Address < ActiveRecord::Base
  belongs_to :user

  geocoded_by :bussiness_address, :latitude  => :lat, :longitude => :lon

  before_save :geocode
  after_save :update_products

  validates_presence_of :country
  validates_presence_of :city
  validates_presence_of :street
  validates_presence_of :zip

  attr_accessible :street, :city, :country, :zip, :user_id

  def bussiness_address
    [street, city, country, zip].compact.join(', ')
  end

  # We update the address for all the products
  # .. although only going to be used for services
  def update_products
    self.user.products.each{|p| p.specific.after_update_address}
  end
end