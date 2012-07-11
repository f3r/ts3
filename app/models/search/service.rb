module Search
  class Service < Search::Product

    def resource_class
      ::Service
    end
    
    def price_range_bounds
      #Save the amenity_filters
      amenity_ids = self.amenity_ids
      self.amenity_ids = []
      range_bounds = super
      #restore it
      self.amenity_ids = amenity_ids
      range_bounds
    end

    def add_filters
    end

    def category_filters
      []
    end

    def amenity_filters
      Amenity.searchable.collect do |a|
        checked = self.amenity_ids && self.amenity_ids.include?(a.id)
        count = nil # TODO count
        [a, count, checked]
      end
    end

    def amenity_filters_title
      I18n.t('services.search.amenity_filter_title')
    end
  end
end
