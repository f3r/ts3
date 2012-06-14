module Search
  class Base < ActiveRecord::Base
    def self.columns
      @columns ||= []
    end

    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end

    def self.default_columns
      column :current_page,     :integer, 1
      column :total_pages,      :integer
      column :sort_by,          :string
      column :currency,         :string
      column :city_id,          :integer
      column :min_price,        :integer
      column :max_price,        :integer

      attr_accessor :product_category_ids
    end

    # Override the save method to prevent exceptions.
    def save(validate = true)
      validate ? valid? : true
    end

    def results
      unless @results
        @results = calculate_results

        # Set order
        @results = @results.order(self.order)

        # Pagination
        @results = @results.paginate(:page => self.current_page, :per_page => 10)
        self.current_page = @results.current_page
        self.total_pages = @results.total_pages
      end
      @results
    end

    def count
      @results = calculate_results
      @results.count
    end

    def calculate(operation, field)
      @results = calculate_results
      results.calculate(operation, field)
    end

    def price_range
      if self.min_price.present? && self.max_price.present?
        Range.new(self.min_price, self.max_price)
      end
    end

    def collection
      raise "Must override"
    end

    def add_filters
      raise "Must override"
    end

    def order
      "created_at DESC"
    end

    def category_filters
      filters = []
    end

    def price_field
      "price_#{self.resource_class.price_unit}"
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

    protected

    def collection
      self.resource_class.published
    end

    def calculate_results
      @conditions = {}
      @sql_conditions = []

      # Prepare conditions
      add_conditions

      # Start with base collection
      @results = self.collection

      # Add hash conditions
      @results = @results.where(@conditions)

      # Add SQL Conditions
      @sql_conditions.each do |cond|
        @results = @results.where(cond)
      end

      @results
    end

    def add_conditions
      add_equals_condition('products.city_id', self.city_id)
      add_equals_condition(price_field, self.price_range)
      add_filters # From override
    end

    def add_equals_condition(key, value)
      @conditions[key] = value unless value.blank?
    end

    def add_like_condition(key, value)
      @conditions["#{key}.like"] = "%#{value}%" unless value.blank?
    end

    def add_boolean_condition(key, value)
      @conditions[key] = value unless value.nil?
    end

    def add_sql_condition(cond)
      @sql_conditions << cond
    end
  end
end