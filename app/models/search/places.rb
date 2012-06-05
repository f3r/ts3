module Search
  class Places < Search::Base
    column :current_page, :integer, 1
    column :total_pages,  :integer
    column :sort_by,      :string

    column :city_id,      :integer
    column :guests,       :integer, 1
    column :currency,     :string
    column :check_in,     :date
    column :check_out,    :date

    # def results
    #   items = 
    #   if self.city_id
    #     items = items.where(:city_id => self.city_id)
    #   end
    #   items.paginate(:page => 1, :per_page => 10)
    # end

    def collection
      Place.with_permissions_to(:read)
    end

    def add_filters
      add_equals_condition(:city_id, self.city_id)
      add_sql_condition(['max_guests >= ?', self.guests]) if self.guests > 1
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
  end
end