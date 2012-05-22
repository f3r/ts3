class Address < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :country
  validates_presence_of :city
  validates_presence_of :street
  validates_presence_of :zip
end