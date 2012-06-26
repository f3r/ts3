class Product < ActiveRecord::Base
  acts_as_superclass

  belongs_to :user
  belongs_to :city
  belongs_to :currency
  belongs_to :category
  has_many   :photos, :dependent => :destroy, :order => :position, :foreign_key => :place_id
  has_many   :favorites, :dependent => :destroy, :as => :favorable
  has_many   :product_amenities, :dependent => :destroy
  has_many   :amenities, :through => :product_amenities
  has_many   :comments, :dependent => :destroy, :foreign_key => :place_id

  attr_accessor :terms

  validates_presence_of  :currency
  before_save :convert_prices_to_usd


  def self.published
    self.where('products.published' => true)
  end

  def self.unpublished
    self.where('not products.published')
  end

  def self.manageable_by(user)
    self.where('products.user_id' => user.id)
  end

  def primary_photo
    if self.photos.first
      self.photos.first.photo(:medsmall)
    else
      'http://placehold.it/150x100'
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


  def price(a_currency = nil, unit = :per_month)
    a_currency ||= Currency.default

    # If we are asked in the original currency of the place
    if self.currency == a_currency.currency_code
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

  # This method is only implemented for services, because the address comes from the profile
  def after_update_address
  end

  protected

  def convert_prices_to_usd
    return true unless currency
    self.price_per_hour_usd = self.currency.to_usd(self.price_per_hour) * 100.0 if self.price_per_hour_changed? && self.price_per_hour
    self.price_per_week_usd = self.currency.to_usd(self.price_per_week) * 100.0 if self.price_per_week_changed? && self.price_per_week
    self.price_per_hour_month = self.currency.to_usd(self.price_per_month) * 100.0 if self.price_per_month_changed? && self.price_per_month
  end



end
