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
  end
 end