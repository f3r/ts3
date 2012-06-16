module Search
  class Places < Search::Base
    column :current_page,     :integer, 1
    column :total_pages,      :integer
    column :sort_by,          :string

    column :city_id,          :integer
    column :guests,           :integer, 1
    column :min_price,        :integer
    column :max_price,        :integer
    column :currency,         :string
    column :check_in,         :date
    column :check_out,        :date

    attr_accessor :place_type_ids

    def price_range
      if self.min_price.present? && self.max_price.present?
        Range.new(self.min_price, self.max_price)
      end
    end

    def collection
      Place.published
    end

    def add_filters
      add_equals_condition(:city_id, self.city_id)
      add_equals_condition(:place_type_id, self.place_type_ids)
      add_sql_condition(['max_guests >= ?', self.guests]) if self.guests > 1
      add_equals_condition(:price_per_month, self.price_range)
    end

    def order
      self.sort_by ||= 'price_lowest'
      sort_map = {
        "name"               => "title asc",
        "price_lowest"       => "price_per_month_usd asc",
        "price_highest"      => "price_per_month_usd desc",
        "price_size_lowest"  => "price_sqf_usd asc",
        "price_size_highest" => "price_sqf_usd desc",
        "reviews_overall"    => "reviews_overall desc",
        "most_recent"        => "updated_at desc"
      }
      sort_map[self.sort_by]
    end


    # Information for filters

    def place_type_filters
      filters = []
      current_types = self.place_type_ids

      PlaceType.all.each do |pt|
        self.place_type_ids = pt.id
        if ((count = self.count) > 0)
          checked = current_types && current_types.include?(pt.id.to_s)
          filters << [pt, count, checked]
        end
      end

      self.place_type_ids = current_types
      filters
    end

    def price_range_bounds
      # Backup the current filter values
      current_prices = [self.min_price, self.max_price]
      self.min_price = self.max_price = nil

      # Calculate the range
      min = self.calculate(:minimum, :price_per_month)
      max = self.calculate(:maximum, :price_per_month)

      # Convert currency

      # Round to multiples of 100
      max = (max/100.0).ceil * 100   if max
      min = (min/100.0).floor * 100  if min

      if min == max
        max = min + 100
      end

      # Restore the filter
      self.min_price, self.max_price = current_prices

      [min, max]
    end
  end
end