class PlacesController < ApplicationController
  layout 'plain'
  before_filter :login_required, :only => [:new, :wizard, :create, :my_places]
  before_filter :find_place, :only => [:wizard, :show, :preview, :photos, :rent, :availability]

  def new
    @place = Heypal::Place.new
  end

  def create
    place_params = params[:place]
    place_params[:access_token] = current_token
    place_params[:currency] = get_current_currency

    @place = Heypal::Place.new(place_params)

    if @place.save
      redirect_to wizard_place_path(@place)
    else
      render :action => :new
    end
  end

  def update
    result = Heypal::Place.update(params_with_token(:place).merge(:id => params[:id]))
    if result['stat'] == "ok"
      place = result['place']
      # filter data
      [:place_type, :user, :photos].each do |k|
        place[k] = nil
      end
      response = {:stat => "ok", :place => place}
    else
      response = {:stat => "fail", :err => result['err'], :error_label => error_codes_to_messages(result['err']).join(', ')}
    end
    render :json => response, :layout => false
  end

  def update_currency
    place = Heypal::Place.update(params_with_token(:place).merge(:id => params[:id]))
    render :json => {:currency_sign => currency_sign_of(place['place']['currency'])}
  end

  def publish
    result = Heypal::Place.publish_check(params[:id], current_token)
    if result['stat'] == "ok"
      result = Heypal::Place.publish(params[:id], current_token)
      flash[:notice] = t(:place_published)
    else
      flash[:error] = t(:place_publish_error)
    end
    redirect_to preview_place_path(:id => params[:id])
  end

  def unpublish
    place = Heypal::Place.unpublish(params[:id], current_token)
    flash[:notice] = t(:place_unpublished)
    redirect_to preview_place_path(:id => params[:id])
  end

  def publish_check
    result = Heypal::Place.publish_check(params[:id], current_token)
    if result['stat'] == "ok"
      response = {:stat => "ok"}
    else
      response = {:stat => "fail", :err => result['err'], :error_label => error_codes_to_messages(result['err']).join(', ')}
    end
    render :json => response, :layout => false
  end

  def wizard
    @place = Heypal::Place.find(params[:id], current_token, nil) # no currency conversion
    
    # filter data
    @place_basic_info = @place
    [:place_type, :user, :photos].each do |k|
      @place_basic_info[k] = nil
    end

    @photos = @place.photos
    @availabilities = Heypal::Availability.find_all({:place_id => @place.to_param}, current_token)
    #@city = Heypal::Geo.find_by_city_id(@place.city_id)
  end

  def preview
    @preview = true
    @comments = Heypal::Comment.find_all({:place_id => @place.to_param}, current_token)

    render(:template => 'places/show', :layout => 'application')
  end

  def show
    @preview = false
    availabilities = Heypal::Availability.find_all({:place_id => @place.to_param}, current_token)

    @availabilities = []
    # FIXME: Implement method in places_helper.rb/cleanup_availabilities
    #availabilities = cleanup_availabilities(availabilities)
    availabilities.each do |a|
        @availabilities << {
          'title'  => price_availability_plain_calendar(a, @place),
          'start'  => Date.parse(a['date_start']), 
          'end'    => Date.parse(a['date_end']), 
          'color'  => color_price(a, @place),
          'allDay' => true
        }
    end unless availabilities.blank?

    @comments = Heypal::Comment.find_all({:place_id => @place.to_param}, current_token)
    render :layout => 'application'
  end

  def photos
    @photos = @place.photos
    render :template => 'places/_photo_list', :layout => false
  end

  # def upload_photo
  #   #@place = Heypal::Place.find(params[:id], params[:token])
  # 
  #   Heypal::Photo.create(params[:id], params[:file], params[:token])
  #   p = Heypal::Photo.new
  #   p.place_id = params[:id]
  #   p.photo_id = Time.now.to_i
  #   p.photo = params[:file]
  #   p.save
  #   photo = {
  #           :photo => {
  #             :id => p.photo_id,
  #             :name => '',
  #             :place_id => params[:id],
  #             :filename => params[:Filename],
  #             :large => p.photo.url(:large, false),
  #             :medium => p.photo.url(:medium, false),
  #             :medsmall => p.photo.url(:medsmall, false),
  #             :small => p.photo.url(:small, false),
  #             :tiny => p.photo.url(:tiny, false),
  #             :original => p.photo.url(:original, false)
  #           }
  #         }
  #
  #   unless @place.photos.nil?
  #     @photos = @place.photos
  #   else
  #     @photos = []
  #   end
  # 
  #   post_params = {:photos => @photos.to_json}
  #   result = Heypal::Place.update(post_params.merge(:id => params[:id], :access_token => params[:token]))
  # 
  #   @place = Heypal::Place.find(params[:id], params[:token])
  #   @photos = @place.photos
  #   render :template => 'places/_photo_list', :layout => false
  # end

  def get_cities
    @cities = Heypal::Geo.get_all_cities(params[:query])
    render :js => @cities.map.collect{|city| [city['name']]}
  end

  # default place search2
  def index
    @city_id = params[:city_id]
    unless @city_id
      if params[:city] == 'hong_kong'
        @city_id = 2
      else
        @city_id = 1
      end
    end

    check_in  = params[:check_in]  rescue nil
    check_out = params[:check_out] rescue nil
    page      = params[:page]
    search_params    = { 
      'check_in'  => check_in,
      'check_out' => check_out,
      'sort'      => 'price_lowest',
      'guests'    => '1',
      'city'      => @city_id,
      'currency'  => get_current_currency,
      'per_page'  => 6,
      'page'      => page
    }
    @results = Heypal::Place.search(search_params)

    min, max = Heypal::Geo.get_price_range(@city_id, get_current_currency) #1 is Sing. Line:28 of LookupsHelper
    if !min.nil? && !max.nil?
      @min_price = min
      @max_price = max
    else
      @min_price = 0
      @max_price = 0
    end

    respond_to do |format|
      format.html
      format.js { render :partial => 'javascript_place' }
    end
  end

  # User
  def search
    page = params[:page]
    params.merge!('per_page' => 6, 'page' => page)
    @results = Heypal::Place.search(params)

    if @results.key?("err")
      render :json => {
        :results       => 0,
        :per_page      => 0,
        :current_page  => 0,
        :total_pages   => 0,
        :place_data    => render_to_string(:_search_results, :locals => {:places => []}, :layout => false),
        :place_filters => ''
      }
    else
      cur_page = @results['current_page'].nil? ? 1 : @results['current_page']
      render :json => {
        :results          => @results['results'], 
        :per_page         => @results['per_page'], 
        :current_page     => cur_page, 
        :place_type_count => @results['place_type_count'],
        :total_pages      => @results['total_pages'], 
        :place_data       => render_to_string(:_search_results, :locals => {:places => @results['places']}, :layout => false),
        :place_filters    => render_to_string(:_place_type_filters, :layout => false)
      }
    end
  end

  def my_places
    @places = Heypal::Place.my_places(current_token, get_current_currency)
  end

  def rent
    if logged_in?
      @user = Heypal::User.show('access_token' => current_token)
      render :layout => 'single'
    else
      flash[:error] = 'You must be logged in to rent a place'
      redirect_to login_path
    end
  end
  
  def availability
    @user = Heypal::User.show('access_token' => current_token)
    @availability = Heypal::Place.availability(params[:id], params[:check_in], params[:check_out], get_current_currency, current_token)
    if @availability.key?("err")
      @errors = @availability["err"]
      render 'rent'
    else
      render :layout => 'plain'
    end
  end
  
  def check_availability
    @availability = Heypal::Place.availability(params[:place_id], params[:check_in], params[:check_out], get_current_currency, current_token)
    if @availability.key?("err")
      error = [params[:fieldId], true]
      if @availability['err'][params[:fieldId]]
        error = [params[:fieldId], false, 'date must be future, after today'] if @availability["err"][params[:fieldId]] && @availability["err"][params[:fieldId]].include?(119)
        error = [params[:fieldId], false, 'end date must be after initial date'] if @availability["err"][params[:fieldId]] && @availability["err"][params[:fieldId]].include?(120)
        error = [params[:fieldId], false, 'occupied'] if @availability["err"]['place'] && @availability["err"]['place'].include?(136)
      end
      error = [params[:fieldId], false, 'occupied'] if @availability["err"]['place'] && @availability["err"]['place'].include?(136)
      render :inline => error.to_json
    else
      render :inline => [params[:fieldId], true].to_json
    end
  end

  def confirm_rental
    @confirm_rental = Heypal::Place.confirm_rental(params[:id], params[:confirm_rental][:check_in], params[:confirm_rental][:check_out], current_token)
    @place = Heypal::Place.find(params[:id], current_token)
    @owner = @place['user']
    render :layout => 'plain'
  end

  def confirm_inquiry
    @confirm_inquiry = Heypal::Place.confirm_inquiry(
      params[:id], 
      {
        :name             => params[:name],
        :email            => params[:email],
        :mobile           => params[:mobile],
        :date_start       => params[:date_start],
        :length_stay      => params[:length_stay],
        :length_stay_type => params[:length_stay_type],
        :questions        => params[:questions]
      },
      current_token
    )
    if @confirm_inquiry['stat'] == 'ok'
      @response = "success"
    else
      @response = "error"
    end
    respond_to do |format|
      format.js { render :layout => false }
    end    
  end

  def destroy
    @place = Heypal::Place.delete(params[:id], current_token)
      if @place['stat'] == 'ok'
        flash[:notice] = 'Place successfully deleted'
      else
        flash[:error] = 'error deleting place'
    end
    redirect_to my_places_path
  end

protected

  def find_place
    @place = Heypal::Place.find(params[:id], current_token, get_current_currency)
    @owner = @place['user']
  end
end
