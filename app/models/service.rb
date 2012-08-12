class Service < ActiveRecord::Base

  as_enum :language_1, [:english, :french, :spanish]
  as_enum :language_2, [:english, :french, :spanish]
  as_enum :language_3, [:english, :french, :spanish]

  before_save :fill_in_address

  if Product.table_exists?
    acts_as :product
    accepts_nested_attributes_for :product
  end

  def self.product_name
    'Service'
  end

  def self.searcher
    Search::Service
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

  #For the active admin
  def self.admin_filters
    #Just enumerate the fields we want to use to filtering in active admin
    ['education_status','seeking']
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
    SiteConfig.price_unit
  end

  def self.transaction_length_units
    [['hour(s)', 'hours']]
  end

  def self.user_reached_limit?(user)
    self.manageable_by(user).count >= 1
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
    if self.user.avatar?
      self.user.avatar.url(:medium)
    else
      ApplicationHelper.static_asset('missing_userpic_200.jpeg')
    end
  end

  def inquiry_photo
    nil
  end

  def fill_in_address
    if (address = self.user.address)
      self.address_1 = address.street
      self.zip = address.zip
      self.lat = address.lat
      self.lon = address.lon
    end
    # because this method is a callback, we should return true so validations do not fail
    true
  end

  # Called from Address
  def after_update_address
    self.fill_in_address
    self.save
  end

  # Default radius for the service/show map (2km)
  def radius
    2000
  end

  def display_name
    self.title
  end


  def language_ids=(ids)
    self.language_1_cd, self.language_2_cd, self.language_3_cd = ids
  end

  def language_ids
    ids = []
    ids << self.language_1_cd if self.language_1_cd
    ids << self.language_2_cd if self.language_2_cd
    ids << self.language_3_cd if self.language_3_cd
    ids
  end

  def spoken_languages
    langs = []
    langs << self.language_1.capitalize if self.language_1
    langs << self.language_2.capitalize if self.language_2
    langs << self.language_3.capitalize if self.language_3
    langs.join(', ') if langs.any?
  end
end