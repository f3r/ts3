class Product < ActiveRecord::Base
  acts_as_superclass

  belongs_to :user
  belongs_to :city
  belongs_to :currency
  belongs_to :category
  has_many   :photos, :dependent => :destroy, :order => :position
  has_many   :favorites, :dependent => :destroy, :as => :favorable
  has_many   :product_amenities, :dependent => :destroy
  has_many   :amenities, :through => :product_amenities
  has_many   :reviews, :dependent => :destroy

  has_many   :q_and_a, :class_name => 'Comment', :dependent => :destroy

  attr_accessor :terms

  validates_presence_of  :currency, :city, :title

  validates_numericality_of :price_per_night, :price_per_hour, :price_per_month, :price_sale, :allow_nil => true

  before_save :convert_prices_to_usd, :index_amenities

  geocoded_by :full_address, :latitude  => :lat, :longitude => :lon

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
    :sale
  end

  def primary_photo
    if self.photos.first
      self.photos.first.photo(:medsmall)
    else
      'http://placehold.it/150x100'
    end
  end

  # Photo representation for the inquiry
  def inquiry_photo
    if self.photos.first
      self.photos.first.photo(:medsmall)
    end
  end

  def publish!
    self.published = true
    self.save
  end

  def unpublish!
    self.published = false
    self.save
  end

  def publish_check!
    self.published = true
    self.valid?
  end

  def price(a_currency = nil, unit = :per_month)
    a_currency ||= Currency.default

    # If we are asked in the original currency of the place
    if self.currency == a_currency
      amount = self.send("price_#{unit}")
    else
      # If we are asked in the 'special' USD (precalculated with before_save callback)
      if a_currency.usd?
        amount = self.send("price_#{unit}_usd")
        amount = amount / 100 if amount
      else
        # Must convert between USD and a_currency
        amount_usd = self.send("price_#{unit}_usd")
        amount = a_currency.from_usd(amount_usd/100.0)
      end
    end
    [a_currency.symbol, amount]
  end

  def full_address
    [address_1, address_2, city.name, city.state, city.country].compact.join(', ')
  end

  def geocoded?
    self.lat.present? && self.lon.present?
  end

  def review_avg
    self.reviews.average(:score).to_i
  end

  def has_any_paid_transactions?(user)
    Transaction.joins(:inquiry).where('state = ?', :paid).where('transactions.user_id = ?', user).where('inquiries.product_id = ?', self.id).count > 0
  end

  def convert_prices_to_usd
    return true unless currency
    [:per_hour, :per_night, :per_week, :per_month, :sale].each do |unit|
      field = "price_#{unit}"
      field_usd = "#{field}_usd"
      if self.changed.include?(field)
        price_value = read_attribute(field)
        if price_value
          price_usd = self.currency.to_usd(price_value) * 100.0
          write_attribute(field_usd, price_usd)
        end
      end
    end
    true
  end

protected

  def after_update_address
  end

  def index_amenities
    ids = self.amenity_ids
    if ids
      self.amenities_search = ids.sort.collect{|id| "<#{id}>"}.join(',')
    else
      self.amenities_search = nil
    end
  end
end
