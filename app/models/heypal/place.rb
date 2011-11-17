class Heypal::Place < Heypal::Base
  include LookupsHelper

  set_resource_path '/places.json'

  @@general_attributes = %w(
    title description place_type_id city_id num_bedrooms num_beds num_bathrooms size sqm sqf max_guests size_type access_token
  )

  @@geo_attributes = %w(
    address_1 address_2 zip directions state_id country_id 
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

      if result['stat'] == 'ok'    
        return normalize_place(result)
      else
        #TODO: display error here.
      end

    end

    def place_types
      result = request("/place_types.json", :get)
      result['place_types']
    end

    def update(options)
      result = request("/places/#{options[:id]}.json", :put, options)
      result
    end

    def find(id, access_token)
      result = request("/places/#{id}.json?access_token=#{access_token}", :get)
      if result['stat'] == 'ok'
        return self.new(normalize_place(result))
      end
    end

    def normalize_place(result)
      # merge the place hash for now
      p = {}
      p = p.merge(result['place']['amenities']) if result['place']['amenities'].present?
      p = p.merge(result['place']['details']) if result['place']['details'].present?
      p = p.merge(result['place']['location']) if result['place']['location'].present?
      p = p.merge(result['place']['terms_of_offer']) if result['place']['terms_of_offer'].present?
      p = p.merge(result['place']['pricing']) if result['place']['pricing'].present?
      p = p.merge(result['place'])

      # cleanup, messy but this should work for now
      #
      p.delete('details')
      p.delete('location')
      p.delete('place_type')

      p['user_id'] = result['place']['user']['id']
      p['place_type_id'] = result['place']['place_type']['id']
      Rails.logger.info "Normalized Params #{p}"
      p    
    end

  end

  def initialize(params = {})
    deserialize(params) if params
    self
  end  

  def save
    if new_record?
      if response = self.class.create(self)
        self.deserialize(response)
        return true
      else
        return false
      end
    else
      if self.class.update(self)
        return true
      else
        return false
      end
    end
  end

  def id
    self['id']
  end

  def valid?
    self['stat'] == 'ok'
  end

  def new_record?
    self['id'].blank?
  end

  def to_param
    self['id'].to_s
  end

  def place_type
    place_types_select.select { |s| s[1] == self.place_type_id }[0].first
  end

  ##
  # Returns the primary photo. The 
  def primary_photo
    photos.first
  end

end
