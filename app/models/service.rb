class Service < ActiveRecord::Base

  as_enum :language_1, [:english, :french, :spanish]
  as_enum :language_2, [:english, :french, :spanish]
  as_enum :language_3, [:english, :french, :spanish]

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

  def self.price_unit
    SiteConfig.price_unit
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