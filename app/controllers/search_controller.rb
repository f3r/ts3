class SearchController < ApplicationController
  layout 'plain'
  before_filter :authenticate_user!, :only => [:favorites]

  def index
    if !request.xhr?
      @city = City.find(params[:city]) if params[:city]
      unless @city
        redirect_to "/#{current_city.slug}"
        return
      end
    end

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

  def favorites
    @results = Favorite.for_user(current_user, Place)
  end

end
