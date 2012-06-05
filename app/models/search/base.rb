module Search
  class Base < ActiveRecord::Base
    def self.columns
      @columns ||= []
    end

    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end

    # Override the save method to prevent exceptions.
    def save(validate = true)
      validate ? valid? : true
    end

    def results
      unless @results
        @conditions = {}
        @sql_conditions = []

        # Prepare conditions
        add_filters

        # Start with base collection
        @results = self.collection

        # Add hash conditions
        @results = @results.where(@conditions)

        # Add SQL Conditions
        @sql_conditions.each do |cond|
          @results = @results.where(cond)
        end

        # Set order
        @results = @results.order(self.order)

        @results = @results.paginate(:page => self.current_page, :per_page => 10)
        self.current_page = @results.current_page
        self.total_pages = @results.total_pages
      end
      @results
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