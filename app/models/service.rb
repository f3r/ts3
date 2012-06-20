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

  def seeking_label
    return unless self.seeking
    opt = self.class.seeking_options.find{|o| o[1] == self.seeking}
    opt[0] if opt
  end

  def education_status_label
    return unless self.education_status
    opt = self.class.education_statuses.find{|o| o[1] == self.education_status}
    opt[0] if opt
  end

  def primary_photo
    self.user.avatar.url(:medium) if self.user.avatar?
  end
end