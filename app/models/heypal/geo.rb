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

    def get_all_cities(params)
      result = request("/geo/cities/search.json?query=#{params}", :get)
      if result['stat'] == 'ok'
        return result['cities']
      end
    end

    def get_price_range(city_id, currency)
      results = request("/geo/cities/#{city_id}/price_range.json?currency=#{currency}", :get)
      if results['stat'] == 'ok'
        return [results['min_price'], results['max_price']]
      end
    end

  end

end
