class Product < ActiveRecord::Base
  acts_as_superclass

  belongs_to :user
  belongs_to :city
  has_many   :photos,          :dependent => :destroy, :order => :position, :foreign_key => :place_id
  has_many   :favorites,       :dependent => :destroy, :as => :favorable

  def primary_photo
    self.photos.first
  end
end
