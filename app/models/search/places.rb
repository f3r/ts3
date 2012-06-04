module Search
  class Places
    def initialize(user, city, params = {})
      @user = user
      @city = city
      @params = params
    end

    def results
      items = Place.with_permissions_to(:read)
      if @city
        items = items.where(:city_id => @city.id)
      end
      items.paginate(:page => 1, :per_page => 10)
    end
  end
end