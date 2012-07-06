class Property <  ActiveRecord::Base
  if Product.table_exists?
    acts_as :product
    accepts_nested_attributes_for :product
  end

  validates_presence_of :category_id, :num_bedrooms, :max_guests, :if => :published?
  validates_numericality_of :num_bedrooms, :num_beds, :num_bathrooms, :size, :max_guests, :allow_nil => true

  #before_save :update_price_sqf_field, validate_stays

  def self.product_name
    'Place'
  end

  def self.searcher
    Search::Property
  end

  def self.price_unit
    :per_month
  end

  def self.transaction_length_units
    [['week(s)', 'weeks'], ['month(s)', 'months']]
  end

  def self.published
    self.where('products.published' => true)
  end

  def self.unpublished
    self.where('not products.published')
  end

  def self.manageable_by(user)
    self.where('products.user_id' => user.id)
  end

  def self.transaction_length_units
    [['week(s)', 'weeks'], ['month(s)', 'months']]
  end

  def self.user_reached_limit?(user)
    false
  end

  def price_unit
    self.class.price_unit
  end

  def radius
    0
  end
end