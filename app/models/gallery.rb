class Gallery < ActiveRecord::Base
  validates_presence_of [:name], :message => "Name can't be empty"
  validates_format_of :name, :with => /\A(^[a-z]{1}[a-z0-9_]+)\Z/, :message => "Invalid name"
  has_many :gallery_items, :dependent => :destroy
end