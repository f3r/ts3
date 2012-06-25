module Search
  class Product < Search::Base

  	# Columns that all searches support
    def self.default_columns
      super

      column :currency,         :string
      column :city_id,          :integer
      column :min_price,        :integer
      column :max_price,        :integer

      attr_reader :category_ids
    end

    def order
      self.sort_by ||= 'price_lowest'
      sort_map = {
        "name"               => "title asc",
        "price_lowest"       => "price_#{self.price_unit}_usd asc",
        "price_highest"      => "price_#{self.price_unit}_usd desc",
        "most_recent"        => "updated_at desc"
      }
      sort_map[self.sort_by]
    end

    def sort_options
     [[I18n.t("products.search.price_lowest"), 'price_lowest'],
      [I18n.t("products.search.price_highest"), 'price_highest']]
    end

    def collection
      self.resource_class.published
    end

    def add_conditions
      add_equals_condition('products.city_id', self.city_id)
      add_equals_condition("products.#{self.price_field}", self.price_range)
      add_filters # From override
    end

    def category_ids=(ids)
      if ids.kind_of?(String)
        ids = ids.split(',')
      end
      @category_ids = ids
    end

    def category_filters
      filters = []
    end

    def resource_class
      Product
    end

    def amenity_filters
      filters = []
    end

    def amenity_filters_title
    end

    def category_filters_title
      I18n.t("products.search.category_filters_title")
    end

    def price_unit
      self.resource_class.price_unit
    end

    def price_field
      "price_#{self.price_unit}"
    end

    def price_range
      if self.min_price.present? && self.max_price.present?
        Range.new(self.min_price, self.max_price)
      end
    end

    def price_range_bounds
      # Backup the current filter values
      current_prices = [self.min_price, self.max_price]
      self.min_price = self.max_price = nil

      # Calculate the range
      min = self.calculate(:minimum, price_field)
      max = self.calculate(:maximum, price_field)

      unless min && max
        return [nil, nil]
      end
      # Convert currency

      # Round to multiples of 100
      max = (max/100.0).ceil * 100
      min = (min/100.0).floor * 100

      if min == max
        max = min + 100
      end

      # Restore the filter
      self.min_price, self.max_price = current_prices

      [min, max]
    end
  end
end