module Search
  class Place < Search::Product
    default_columns
    column :guests,           :integer, 1
    column :check_in,         :date
    column :check_out,        :date
    column :min_lat ,         :string
    column :max_lat,          :string
    column :min_lng,          :string
    column :max_lng,          :string

    def resource_class
      ::Place
    end

    attr_accessor :place_type_ids

    def price_range
      if self.min_price.present? && self.max_price.present?
        Range.new(self.min_price, self.max_price)
      end
    end

    def collection
      resource_class.published
    end

    def add_conditions
      add_equals_condition(:city_id, self.city_id)
      add_equals_condition(price_field, self.price_range)

      add_equals_condition(:place_type_id, self.category_ids)
      add_sql_condition(['max_guests >= ?', self.guests]) if self.guests > 1

      if !self.min_lat.blank? && !self.max_lat.blank? && !self.min_lng.blank? &&  !self.max_lng.blank?
        add_sql_condition(['lat BETWEEN ? AND ?' , self.min_lat ,self.max_lat])
        add_sql_condition(['lon BETWEEN ? AND ?' ,self.min_lng ,self.max_lng])
      end
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

    def sort_options
      custom_options = [[I18n.t("places.search.price_size_lowest"), 'price_size_lowest'],
                        [I18n.t("places.search.price_size_highest"), 'price_size_highest']]
      super + custom_options
    end

    # Information for filters
    def category_filters
      filters = []
      current_types = self.category_ids

      PlaceType.all.each do |pt|
        self.category_ids = pt.id
        if ((count = self.count) > 0)
          checked = current_types && current_types.include?(pt.id.to_s)
          filters << [pt, count, checked]
        end
      end

      self.category_ids = current_types
      filters
    end
  end
end