class Heypal::City

  CITIES = [{id: 1, name: :singapore}, {id: 2, name: :hong_kong}, {id: 4, name: :kuala_lumpur}]

  attr_accessor :id, :code

  def self.all
   @all ||= CITIES.collect{|city| self.new(city[:id], city[:name])}
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

  def initialize(id, name)
  	@id = id
    @code = name.to_sym
  end

  def name
  	I18n.t(self.code)
  end
end