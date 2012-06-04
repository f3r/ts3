class SearchController < ApplicationController
  layout 'plain'

  def index
    @city = City.find(params[:city]) if params[:city]
    @search = Search::Places.new(current_user, @city, params)
    @results = @search.results
  end

end
