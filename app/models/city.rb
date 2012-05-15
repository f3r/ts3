class City < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  default_scope order: 'position ASC'
  has_many :places

  before_save :update_cached_complete_name
  after_commit  :delete_cache

  scope :active,    where("active")
  scope :inactive,  where("not active")

  def self.routes_regexp
  	# Matches the name of a city
  	Regexp.new(self.all.collect(&:slug).join('|'))
  end

  def activate!
    self.active = true
    self.save
  end

  def deactivate!
    self.active = false
    self.save
  end

  def complete_name
    "#{self.name}, #{self.state}, #{self.country}".gsub(", ,",",")
  end

  def update_cached
    self.update_attribute(:cached_complete_name, self.complete_name)
  end

  def code
    self.slug.to_sym
  end

  def country_name
    self.country
  end

  private

  def update_cached_complete_name
    unless self.cached_complete_name == self.complete_name
      self.update_cached
    end
  end

  # Expires the cache after a city is modified or added
  def delete_cache
    delete_caches([
      "geo_cities_all_active",
      "geo_cities_all",
      'geo_cities_' + country_code,
      'geo_cities_' + country_code + '_' + (state ? state.parameterize : "")
    ])
  end

  # def name
  #   I18n.t(self.code)
  # end
  # 
  # def country_name
  #   I18n.t(self.country_code)
  # end

end