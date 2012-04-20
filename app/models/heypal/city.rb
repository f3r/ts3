class Heypal::City < Heypal::Base

  attr_accessor :id, :code, :country_code

  def self.all_active
    cities = []
    result = request("/geo/cities.json?active=1", :get)
    if result['stat'] == 'ok'
      cities = result['cities'].map{ |city| self.new(city["id"], city["name"].parameterize("_"), city["country_code"])}
    end
  end

  def self.all
    cities = []
    result = request("/geo/cities.json", :get)
    if result['stat'] == 'ok'
      cities = result['cities'].map{ |city| self.new(city["id"], city["name"].parameterize("_"), city["country_code"])}
    end
  end

  def self.routes_regexp
  	# Matches the name of a city
  	Regexp.new(self.all.collect(&:code).join('|'))
  end

  def self.find_by_id(id)
    self.all.find{|city| city.id.to_s == id.to_s}
  end

  def self.find_by_name(code)
    self.all.find{|city| city.code == code.to_sym}
  end

  def initialize(id, name, country_code)
  	@id = id
    @code = name.to_sym
    @country_code = country_code
  end

  def name
  	I18n.t(self.code)
  end

  def country_name
  	I18n.t(self.country_code)
  end

end