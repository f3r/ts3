class SearchController < ApplicationController
  layout 'plain'

  def index
    @city = City.find(params[:city]) if params[:city]

    @search = Search::Places.new(params[:search])
    @search.city_id = @city.id if @city
    @results = @search.results

    respond_to do |format|
      format.js {
        if params[:submitted_action] == 'see_more'
          render :template => "/search/more_results", :layout => false
        else
          render :template => "/search/refresh", :layout => false
        end
      }

      format.html { render :template => "/search/index" }
    end
  end

  def show
    @place = Place.published.find(params[:id])
    @owner = @place.user
  end

end
