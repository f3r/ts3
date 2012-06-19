class Service < ActiveRecord::Base
  if Product.table_exists?
    acts_as :product
  end

  def self.published
    self.where('products.published' => true)
  end

  def self.manageable_by(user)
    self.where('products.user_id' => user.id)
  end

  def self.searcher
    Search::Service
  end

  def self.education_statuses
    [['Completed', 'completed'], ['Student', 'student']]
  end

  def self.seeking_options
    [['Live in', 'live_in'], ['Live out', 'live_out']]
  end

  def self.education_statuses
    [['Completed', 'completed'], ['Student', 'student']]
  end

  def self.price_unit
    :per_hour
  end

  def price_unit
    self.class.price_unit
  end

  def price(a_currency, unit)
    self.product.price(a_currency, unit)
  end
end