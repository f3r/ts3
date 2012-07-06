module Search
  class Product < Search::Base

  	# Columns that all searches support
    def self.default_columns
      super

      column :currency_id,      :integer
      column :city_id,          :integer
      column :min_price,        :integer
      column :max_price,        :integer
      column :min_lat,          :string
      column :max_lat,          :string
      column :min_lng,          :string
      column :max_lng,          :string

      attr_reader :category_ids
      attr_reader :amenity_ids
    end

    default_columns

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
      resource_class.published
    end

    def add_conditions
      add_equals_condition('products.city_id', self.city_id)
      add_equals_condition("products.#{self.price_field}", self.price_range)
      add_equals_condition('products.category_id', self.category_ids)
      add_amenities_condition('products.amenities_search', self.amenity_ids)

      if !self.min_lat.blank? && !self.max_lat.blank? && !self.min_lng.blank? &&  !self.max_lng.blank?
        add_sql_condition(['lat BETWEEN ? AND ?' , self.min_lat, self.max_lat])
        add_sql_condition(['lon BETWEEN ? AND ?' , self.min_lng, self.max_lng])
      end

      add_filters # From override
    end

    def add_filters
      # Optional override
    end

    def category_ids=(ids)
      if ids.kind_of?(String)
        ids = ids.split(',')
      end
      @category_ids = ids
    end

    # Information for filters
    def category_filters
      filters = []
      current_types = self.category_ids

      Category.all.each do |pt|
        self.category_ids = pt.id
        if ((count = self.count) > 0)
          checked = current_types && current_types.include?(pt.id.to_s)
          filters << [pt, count, checked]
        end
      end

      self.category_ids = current_types
      filters
    end

    def resource_class
      ::Product
    end

    def amenity_ids=(ids)
      if ids.kind_of?(String)
        ids = ids.split(',')
      end
      @amenity_ids = ids
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
      resource_class.price_unit
    end

    def price_field
      "price_#{self.price_unit}_usd"
    end

    def price_range
      if self.min_price.present? && self.max_price.present?
        Range.new(self.convert_to_usd(self.min_price), self.convert_to_usd(self.max_price))
      end
    end

    def currency=(a_currency)
      self.currency_id = a_currency.id
    end
    
    def currency
      Currency.find(self.currency_id) if self.currency_id
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

      [self.convert_from_usd(min), self.convert_from_usd(max)]
    end
    
    def convert_from_usd(amount)
      return self.currency.from_usd(amount) / 100 if self.currency
      amount
    end
    
    def convert_to_usd(amount)
      return self.currency.to_usd(amount) * 100 if self.currency
      amount
    end
    
    protected

    def add_amenities_condition(field, ids)
      return if ids.blank?

      str_search = ids.sort.collect{|id| "<#{id}>"}.join('%')
      add_like_condition(field, str_search)
    end

  end
end