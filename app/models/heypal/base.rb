##
# Proxy class for Heypal REST client. It currently uses the RestClient gem for now.
class Heypal::Base

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

  end

end
