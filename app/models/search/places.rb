module Search
  class Places < Search::Base
    column :current_page, :integer
    column :total_pages,  :integer
    column :sort_by,      :string

    column :city_id,   :integer
    column :guests,    :integer, 1
    column :currency,  :string
    column :check_in,  :date
    column :check_out, :date

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
    end
  end
end