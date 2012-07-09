class SearchController < ApplicationController
  layout 'plain'
  before_filter :authenticate_user!, :only => [:favorites, :alert]

  def index
    if !request.xhr?
      @city = City.find(params[:city]) if params[:city]
      unless @city
        redirect_to "/#{current_city.slug}"
        return
      end
    end

    @search = searcher.new(params[:search])

    @search.currency ||= current_currency
    @search.city_id = @city.id if @city
    @results = @search.results

    @alert = Alert.new
    @alert.search_id = @search.id
    @alert_params = @alert

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

  def alert
    alert = current_user.alerts.find(params[:alert_id])
    show_alert_search(alert,false)
  end

  def code
    alert = Alert.unscoped.find_by_search_code(params[:search_code])
    show_alert_search(alert)
  end

  def show
    @resource = resource_class.published.find(params[:id])
    @owner = @resource.user
  end

  def favorites
    @results = Favorite.for_user(current_user, resource_class)
  end

  protected

  def searcher
    resource_class.searcher
  end

  private

  def show_alert_search(alert, act_as_new = true)
    @search = alert.search.detach
    @city = City.find(@search.city_id)
    @results = @search.results
    @alert = alert
    if act_as_new
      @alert = alert.dup
      @alert.search = @search
    end
    render 'search/index'
  end
end
