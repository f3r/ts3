class Property <  ActiveRecord::Base
  if Product.table_exists?
    acts_as :product
  end

  validates_presence_of :title, :category_id, :num_bedrooms, :max_guests

  def self.name
    'Place'
  end

  def self.searcher
    Search::Property
  end

  def self.price_unit
    :per_month
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

  def price_unit
    self.class.price_unit
  end
end