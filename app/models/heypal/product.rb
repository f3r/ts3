class Heypal::Product < Heypal::Base

  class << self
    def find(options = {})
      results = self.get(Heypal::PRODUCTS_URL, options)
      JSON.parse(results)
    end
  end

end
