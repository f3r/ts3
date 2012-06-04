class SearchController < ApplicationController
  layout 'plain'

  def index
    @city = City.find(params[:city]) if params[:city]
    #params.slice(:city_id, :currency, :guests, :check_in, :check_out, :current_page, :sort_by)
    @search = Search::Places.new(params[:search])
    @results = @search.results
  end

end
