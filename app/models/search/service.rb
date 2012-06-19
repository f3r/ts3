module Search
  class Service < Search::Base
    default_columns

    def resource_class
      ::Service
    end

    def add_filters
    end

    def category_filters
      []
    end

    def amenity_filters
      filters = []
      # current_types = self.category_ids

      # PlaceType.all.each do |pt|
      #   self.category_ids = pt.id
      #   if ((count = self.count) > -1)
      #     checked = current_types && current_types.include?(pt.id.to_s)
      #     filters << [pt, count, checked]
      #   end
      # end

      # self.category_ids = current_types

      filters << [Amenity.new, 4, 0]
      filters << [Amenity.new, 2, 1]
      filters << [Amenity.new, 1, 1]
      filters
    end
  end
 end