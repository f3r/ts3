class Heypal::Product < Heypal::Base

  class << self
    def find(type, options = {})
      if type == :first
        find_all(options).first
      elsif type == :all
        find_all(options)
      else
        find_one(type, options = {})
      end
    end

    def find_one(id, options)
      options[:id] = id if options[:id].blank?
      find_all(options).first
    end

    def find_all(options = {})
      results = self.get(Heypal::PRODUCTS_URL, options)
      JSON.parse(results)
    end
    alias_method :all, :find_all

  end

end
