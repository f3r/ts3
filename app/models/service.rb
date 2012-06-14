class Service < ActiveRecord::Base
  acts_as :product

  def self.published
    self.where('products.published' => true)
  end

  def self.manageable_by(user)
    self.where('products.user_id' => user.id)
  end

  def self.searcher
    Search::Service
  end

  def self.price_unit
    :per_hour
  end

  def price_unit
    self.class.price_unit
  end
end