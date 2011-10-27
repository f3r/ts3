##
# Proxy class for Heypal REST client. It currently uses the RestClient gem for now.
class Heypal::Base < Hash
  include ActiveModel::AttributeMethods
  include ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Dirty

  class << self

    def get(url, options = {})
      RestClient.get(url, options)
    end

    def put(url, options = {})
      RestClient.put(url, options)
    end

    def post(url, options = {})
      RestClient.post(url, options)
    end

    def delete(url, options = {})
      RestClient.delete(url, options)
    end

    def request(path, method = :get, options = {})

      Rails.logger.info "Sending to #{path} / #{method} / #{options}"
  
      # Since we're requesting from a static page which doesn't support other http methods
      #result = get(resource_url(path), options)

      result = case method 
        when :get
          get(resource_url(path), options)
        when :put
          put(resource_url(path), options)
        when :post
          post(resource_url(path), options)
        when :delete
          delete(resource_url(path), options)
      end  

      parse_json(result)

    end

    def find(type, options = {})      
      if type == :first
        find_all(options).first
      elsif type == :all
        find_all(options)
      else
        self.new.merge(find_one(type, options))
      end
    end

    def find_one(id, options)
      options[:id] = id if options[:id].blank?
      results = self.get(resource_url(options[:resource_path]), options)
      parse_json(results)
    end

    def find_all(options = {})
      results = self.get(resource_url(options[:resource_path]), options)
      parse_json(results)
    end
    alias_method :all, :find_all

    def resource_url(path = nil)
      Heypal.base_url + (path.present? ? path : resource_path)
    end

    def set_resource_path(path)
      (class << self; self; end).instance_eval do

        define_method :resource_path do
          path
        end

      end
    end

    def parse_json(str)
      JSON.parse str
      #TODO: raise some Heypal::Error::InvalidResponseWhatever in here
    end

  end



end
