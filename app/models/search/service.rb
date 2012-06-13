module Search
  class Service < Search::Base
    default_columns

    def collection
      ::Service.published
    end

    def add_filters
    end
  end
 end