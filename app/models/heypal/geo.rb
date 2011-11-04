class Heypal::Geo < Heypal::Base

  attr_accessor :id, :name, :lat, :lon, :state, :country

  class << self

    def find_by_city_id(city_id)
      result = request("/geo/cities/#{city_id}.json", :get)
      if result['stat'] == 'ok'
        return result['city']
      end
    end

    def find_by_city_name(name)

    end

  end

end
