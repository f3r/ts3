class Heypal::Availability < Heypal::Base

  set_resource_path '/availabilities.json'

  @@attributes = %w(availability_type date_start end_start price_per_night comment)
  @@attributes.each { |attr| attr_accessor attr.to_sym }

  define_attribute_methods = @@attributes

  class << self
    def create(params)
      result = request("/places/#{params[:place_id]}/availabilities.json", :post, params)

      if result['stat'] == 'ok'
        return get_data_on(result)
      else
        return get_errors_on(result)
      end
    end

    def update(params)
      result = request("/places/#{params[:place_id]}/availabilities/#{params[:id]}.json", :put, params)

      if result['stat'] == 'ok'
        return get_data_on(result)
      else
        return get_errors_on(result)
      end
    end

    def find_all(params)
      result = request("/places/#{params[:place_id]}/availabilities.json")
      if result["stat"] == 'ok'
        result["availabilities"]
      else
        {}
      end
    end

    def delete(id, params)
      result = request("/places/#{params[:place_id]}/availabilities/#{id}.json?access_token=#{params[:access_token]}", :delete, params)

      result['stat'] == 'ok' ? true : false
    end

    def get_data_on(result)
      [true, result["availability"]]
    end

    def get_errors_on(result)
      [false, result["err"]]
    end
  end
  
  def initialize(params = {})
    deserialize(params) if params
    self
  end

  def save
    if new_record?
      saved, response = self.class.create(self)

      if saved
        self.deserialize(response)
        return [true, response]
      else
        return [false, response]
      end
    else
      if self.class.update(self)
        return true
      else
        return false
      end
    end
  end

  def new_record?
    self['id'].blank?
  end
end
