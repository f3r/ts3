##
# Proxy class for Heypal REST client. It currently uses the RestClient gem for now.
class Heypal::Base < Hash

  class << self

    def get(url, options = {})
      RestClient.get(url, options)
    end

    def put(url, options = {})
      RestClient.put(url, options)
    end

    def post(url, options = {})
      RestClient.post(options)
    end

    def delete(url, options = {})
      RestClient.delete(options)
    end

    def find(type, options = {})
      if type == :first
        find_all(options).first
      elsif type == :all
        find_all(options)
      else
        self.new.merge(find_one(type, options = {}))
      end
    end

    def find_one(id, options)
      options[:id] = id if options[:id].blank?
      results = self.get(Heypal::PRODUCT_URL, options)
      JSON.parse(results)
    end

    def find_all(options = {})
      results = self.get(Heypal::PRODUCTS_URL, options)
      JSON.parse(results)
    end
    alias_method :all, :find_all    

  end



end
