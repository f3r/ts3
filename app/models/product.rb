class Product < ActiveRecord::Base
  acts_as_superclass

  belongs_to :user
  belongs_to :city
  belongs_to :currency
  has_many   :photos, :dependent => :destroy, :order => :position, :foreign_key => :place_id
  has_many   :favorites, :dependent => :destroy, :as => :favorable
  has_many   :product_amenities, :dependent => :destroy
  has_many   :amenities, :through => :product_amenities

  def self.published
    self.where('products.published' => true)
  end

  def self.manageable_by(user)
    self.where('products.user_id' => user.id)
  end

  def primary_photo
    self.photos.first
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
      else
        # Must convert between USD and a_currency
        amount_usd = self.send("price_#{unit}_usd")
        amount = a_currency.from_usd(amount_usd/100.0).to_f.to_i
      end
    end
    [a_currency.symbol, amount]
  end
end
