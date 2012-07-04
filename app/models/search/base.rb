module Search
  class Base < ActiveRecord::Base
    def self.columns
      @columns ||= []
    end

    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end

    # Columns that all searches support
    def self.default_columns
      # Pagination and ordering
      column :current_page,     :integer, 1
      column :total_pages,      :integer
      column :sort_by,          :string
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

    def collection
      raise "Must override"
    end

    def add_conditions
      raise "Must override"
    end

    protected

    def prepare_conditions
      @conditions = {}
      @sql_conditions = []
      self.add_conditions
    end

    def calculate_results
      # Prepare conditions
      self.prepare_conditions

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

    def add_equals_condition(key, value)
      @conditions[key] = value unless value.blank?
    end

    def add_like_condition(key, value)
      @sql_conditions << ["#{key} like ?", "%#{value}%"] unless value.blank?
    end

    def add_boolean_condition(key, value)
      @conditions[key] = value unless value.nil?
    end

    def add_sql_condition(cond)
      @sql_conditions << cond
    end
  end
end