class Heypal::Place < Heypal::Base
  include LookupsHelper

  set_resource_path '/places.json'

  @@general_attributes = ["title", "description", "place_type_id", "city_id", "num_bedrooms", "num_beds", "num_bathrooms", "size_sqm", "size_sqf", "max_guests", "size_unit", "access_token", "published"]
  @@geo_attributes = ["address_1", "address_2", "zip", "directions", "state_id", "country_id", "city_name", "country_name"]
  @@amenities_attributes = ["amenities_aircon", "amenities_breakfast", "amenities_buzzer_intercom", "amenities_cable_tv", "amenities_dryer", "amenities_doorman", "amenities_elevator", "amenities_family_friendly", "amenities_gym", "amenities_hot_tub", "amenities_kitchen", "amenities_handicap", "amenities_heating", "amenities_hot_water", "amenities_internet", "amenities_internet_wifi", "amenities_jacuzzi", "amenities_parking_included", "amenities_pets_allowed", "amenities_pool", "amenities_smoking_allowed", "amenities_suitable_events", "amenities_tennis", "amenities_tv", "amenities_washer"] 
  @@pricing_attributes = ["currency", "price_per_night", "price_per_week", "price_per_month", "price_final_cleanup", "price_security_deposit"] 
  @@terms_attributes = ["check_in_after", "check_out_before", "minimum_stay", "maximum_stay", "stay_unit", "house_rules", "cancellation_policy"] 
  @@attributes = @@general_attributes + @@geo_attributes + @@amenities_attributes + @@pricing_attributes + @@terms_attributes

  @@attributes.each { |attr| attr_accessor attr.to_sym }

  attr_accessor :place_size, :photos

  define_attribute_methods = @@attributes

  validates :title, :place_type_id, :num_bedrooms, :num_beds, :max_guests, :city_id, :presence => true
  validates :terms, :acceptance => true


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

    def publish(id, access_token)
      result = request("/places/#{id}/publish.json?access_token=#{access_token}", :get)
      result
    end

    def unpublish(id, access_token)
      result = request("/places/#{id}/unpublish.json?access_token=#{access_token}", :get)
      result
    end

    def publish_check(id, access_token)
      result = request("/places/#{id}/publish_check.json?access_token=#{access_token}", :get)
      result
    end

    def find(id, access_token, currency="USD")
      result = request("/places/#{id}.json?access_token=#{access_token}&currency=#{currency}", :get)
      if result['stat'] == 'ok' && result.key?("place")
        return self.new(normalize_place(result))
      else
        []
      end
    end

    def availability(id, check_in, check_out, currency, access_token)
      result = request("/places/#{id}/check_availability.json?access_token=#{access_token}&currency=#{currency}&check_in=#{check_in}&check_out=#{check_out}", :get)
    end

    def request_rental(id, access_token)
      result = request("/transactions/#{id}/request_rental.json?access_token=#{access_token}", :post)
    end

    def preapprove_rental(id, access_token)
      result = request("/transactions/#{id}/preapprove_rental.json?access_token=#{access_token}", :post)
    end

    def cancel_rental(place_id, transaction_id, access_token)
      result = request("/places/#{place_id}/transactions/#{transaction_id}/cancel.json?access_token=#{access_token}", :post)
    end

    def confirm_inquiry(id, options, access_token)
      result = request("/places/#{id}/inquire.json?access_token=#{access_token}", :post, options)
    end

    def normalize_place(result)
      # merge the place hash for now
      p = {}
      p = p.merge(result['place']['amenities'])      if result['place']['amenities'].present?
      p = p.merge(result['place']['details'])        if result['place']['details'].present?
      p = p.merge(result['place']['location'])       if result['place']['location'].present?
      p = p.merge(result['place']['terms_of_offer']) if result['place']['terms_of_offer'].present?
      p = p.merge(result['place']['pricing'])        if result['place']['pricing'].present?
      p = p.merge(result['place'])

      # cleanup, messy but this should work for now
      p.delete('details')
      p.delete('location')
      p.delete('place_type')

      p['user_id'] = result['place']['user']['id']
      p['place_type_id'] = result['place']['place_type']['id']
      p
    end

    def search(params = {}, access_token)
      q = ''
      params.each do |k, v|
        next if k == 'action' || k == 'controller'
        next if v.blank?

        if v.class.eql?(Array)
          if k == 'place_type_ids'
            v.each do |id_|
              q << "q[place_type_id_eq_any][]=#{id_}&"
            end
          end
        else
          if %w(sort m page city city_id per_page min_price max_price currency guests check_in check_out total_days).include? k
            q << "#{k}"
          else
            q << "q[#{k}]"
          end

          q << "=#{v}&"
        end
      end
      q.chomp!('&')

      request("/places/search.json?#{q}&access_token=#{access_token}", :get)
    end
    
    def my_places(access_token, currency)
      result = request("/users/me/places.json?status=any&currency=#{currency}&access_token=#{access_token}", :get)
      result['places']
    end

    def delete(id, access_token)
      result = request("/places/#{id}.json?access_token=#{access_token}", :delete)
    end
    
    def upload_photo(id, photo, access_token)
      result = request("/places/#{id}/photos.json?access_token=#{access_token}", :post, :photo => phot)
    end

    def add_favorite(id, access_token)
      result = request("/places/#{id}/add_favorite.json?access_token=#{access_token}", :get)
      result
    end

    def remove_favorite(id, access_token)
      result = request("/places/#{id}/remove_favorite.json?access_token=#{access_token}", :get)
      result
    end

    def favorite_places(access_token, currency)
      result = request("/users/me/favorite_places.json?access_token=#{access_token}", :get)
      result
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

  # Virtual attribute for size (sqm/sqf) and size type
  def place_size
    if size_unit == 'meters'
      size_sqm
    elsif size_unit == 'feet'
      size_sqf
    end
  end

  def place_size=(v) 
    if size_unit == 'meters'
      size_sqm = v
    elsif size_unit == 'feet'
      size_sqf = v
    else
      size_sqm = v
      size_unit = 'meters'
    end
  end

end
