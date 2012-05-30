class Currency < ActiveRecord::Base
  default_scope :order => 'currency_code ASC'

  validates_presence_of :name
  validates_presence_of :symbol

  scope :active,    where("active")
  scope :inactive,  where("not active")

  def self.default
    self.first
  end

  def label
    "#{self.currency_code} #{self.symbol}"
  end

  def activate!
    self.active = true
    self.save
  end

  def deactivate!
    self.active = false
    self.save
  end

end