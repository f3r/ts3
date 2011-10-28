class Heypal::Place < Heypal::Base

  set_resource_path '/places.json'

  @@general_attributes = %w(
    title description place_type_id num_bedrooms num_beds sqm sqf max_guests  
  )

  @@geo_attributes = %w(
    city_id address_1 address_2 zip directions
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


  class << self 
    def create(options)
      self.new.merge(request('/places.json', :post, options))
    end

    def update(options)
      self.new.merge(request('/places.json', :put, options))
    end

  end

  # MOCK them up for now
  def save
    return true
    if new_record?
      self.class.create(self)
    else
      self.update(self.merge(:id => self.id))
    end
  end

  def id
    return 1
  end

  def new_record?
    self['id'].present?
  end

  def to_param
    id.to_s
  end

end
