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

    def base_conditions
      raise "Must override"
    end

    def add_filters
      raise "Must override"
    end

    def add_equals_condition
    end
  end
end