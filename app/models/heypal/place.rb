class Heypal::Place < Heypal::Base

  set_resource_path '/places.json'

  @@general_attributes = %w(
    title description place_type_id city_id num_bedrooms num_beds sqm sqf max_guests access_token 
  )

  @@geo_attributes = %w(
    address_1 address_2 zip directions
  )

  @@amenities_attributes = %w(amenities_aircon amenities_breakfast amenities_buzzer_intercom amenities_cable_tv amenities_dryer amenities_doorman amenities_elevator amenities_family_friendly amenities_gym amenities_hot_tub amenities_kitchen amenities_handicap amenities_heating amenities_hot_water amenities_internet amenities_internet_wifi amenities_jacuzzi amenities_parking_included amenities_pets_allowed amenities_pool amenities_smoking_allowed amenities_suitable_events amenities_tennis amenities_tv amenities_washer)

  @@pricing_attributes = %w(
    currency price_per_night price_per_week price_per_month price_final_cleanup price_security_deposit 
  )

  @@terms_attributes = %w(
    check_in_after check_out_before minimum_stay_days maximum_stay_days house_rules cancellation_policy
  )

  @@attributes = @@general_attributes + @@geo_attributes + @@amenities_attributes + @@pricing_attributes + @@terms_attributes

  @@attributes.each { |attr| attr_accessor attr.to_sym }

  define_attribute_methods = @@attributes

  validates :title, :place_type_id, :num_bedrooms, :num_beds, :max_guests, :city_id, :presence => true

  validates :terms, :acceptance => true

  attr_accessor :photos

  class << self 

    def create(options)
      result = request('/places.json', :post, options)

      #Result {"stat"=>"ok", "place"=>{"id"=>6, "details"=>{"title"=>"Eastwood", "num_bedrooms"=>1, "max_guests"=>1}, "location"=>{"country_id"=>177, "state_id"=>1661, "city_id"=>22186}, "user"=>{"id"=>22}, "place_type"=>{"id"=>1, "name"=>"Apartment"}}}

      if result['stat'] == 'ok'
        return self.new(result)
      else
        #TODO: display error here.
      end

    end

    def update(options)
      result = request('/places.json', :put, options)
      result['stat'] == 'ok'
    end

    def find(id)
      result = request('/places/' + id + '.json' , :get)
      if result['stat'] == 'ok'
        self.new(result['place'])
      end

    end

    def parse(hash)
      new_place = self.new

      new_place.id = hash['place']['id']
    end

  end

  #def initialize(params = {})
    #@@general_attributes.each do |attr|
      #instance_variable_set("@#{attr}", params[attr])
      #self[attr] = params[attr]
    #end
  #end  

  def save
    return self.class.create(self)
    #if new_record?
      #if self.class.create(self)
        #return true
      #else 
        #return false
      #end
    #else
      #if self.class.update(self)
        #return true
      #else
        #return false
      #end
    #end
  end

  def id
    self['id']
  end

  def valid?
    self['stat'] == 'ok'
  end

  def new_record?
    true
    #self['id'].present?
  end

  def to_param
    id.to_s
  end

end
