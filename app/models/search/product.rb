module Search
  class Product < Search::Base

    has_and_belongs_to_many :amenities,
                            :class_name => "::Amenity",
                            :join_table => 'search_amenities',
                            :foreign_key => 'search_id'
    has_and_belongs_to_many :categories,
                      :class_name => "::Category",
                      :join_table => 'search_categories',
                      :foreign_key => 'search_id'
    
    belongs_to :currency
    
    # This is used when the search is used with alert mail
    # 
    attr_accessor :exclude_ids
    
    # This is used to find the recently added results
    attr_accessor :date_from


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
      
      if self.exclude_ids.present?
        add_sql_condition(["#{resource_class.table_name}.id not in (?)", exclude_ids])
      end
      
      if self.date_from.present?
        add_sql_condition(["#{resource_class.table_name}.created_at > ?", self.date_from])
      end

      add_filters # From override
    end

    def add_filters
      # Optional override
    end

    def category_ids=(ids)
      if ids.kind_of?(String)
        ids = ids.gsub("[","").gsub("]","")
        ids = ids.split(',')
      end
      super(ids)
    end

    # Information for filters
    def category_filters
      filters = []
      current_types = self.category_ids
      Category.all.each do |pt|
        self.category_ids = pt.id
        if ((count = self.count) > 0)
          checked = current_types && current_types.include?(pt.id)
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
        ids = ids.gsub("[","").gsub("]","")
        ids = ids.split(',')
      end
      super(ids)
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

    #We need deep copy of the search - but not tied to the db
    #So it behaves as new record - and if needed we can save it
    def detach
      other = self.class.new
      other.sort_by      = self.sort_by
      other.currency_id  = self.currency_id
      other.city_id      = self.city_id
      other.min_price    = self.min_price
      other.max_price    = self.max_price
      other.min_lat      = self.min_lat
      other.max_lat      = self.max_lat
      other.min_lng      = self.min_lng
      other.max_lng      = self.max_lng
      other.category_ids = self.category_ids
      other.amenity_ids  = self.amenity_ids
      other.exclude_ids  = self.exclude_ids
      other.date_from    = self.date_from
      other
    end

    protected

    def add_amenities_condition(field, ids)
      return if ids.blank?

      str_search = ids.sort.collect{|id| "<#{id}>"}.join('%')
      add_like_condition(field, str_search)
    end

  end
end