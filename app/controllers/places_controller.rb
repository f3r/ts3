class PlacesController < PrivateController
  layout 'plain'
  before_filter :find_place, :only => [:wizard, :show, :preview, :photos, :rent, :availability]

  def index
    @results = current_user.places
  end

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
      flash[:notice] = t("places.messages.place_published")
    else
      flash[:error] = t("places.messages.place_publish_error")
    end
    redirect_to preview_place_path(:id => params[:id])
  end

  def unpublish
    place = Heypal::Place.unpublish(params[:id], current_token)
    flash[:notice] = t("places.messages.place_unpublished")
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

  def show
    @preview = true

    render 'search/show'
  end

  # def show
  #   @preview = false
  #   availabilities = Heypal::Availability.find_all({:place_id => @place.to_param}, current_token)
  # 
  #   @availabilities = []
  #   # FIXME: Implement method in places_helper.rb/cleanup_availabilities
  #   #availabilities = cleanup_availabilities(availabilities)
  #   availabilities.each do |a|
  #       @availabilities 
  #        {
  #         'title'  => price_availability_plain_calendar(a, @place),
  #         'start'  => Date.parse(a['date_start']), 
  #         'end'    => Date.parse(a['date_end']), 
  #         'color'  => color_price(a, @place),
  #         'allDay' => true
  #       }
  #   end unless availabilities.blank?
  # 
  #   @comments = Comment.where(:place_id => @place.id).questions
  #   render :layout => 'application'
  # end

  def photos
    @photos = @place.photos
    render :template => 'places/_photo_list', :layout => false
  end

  def destroy
    @place = Heypal::Place.delete(params[:id], current_token)
      if @place['stat'] == 'ok'
        flash[:notice] = t("places.messages.place_deleted")
      else
        flash[:error] = t("places.messages.place_deletion_error")
    end
    redirect_to my_places_path
  end

protected

  def find_place
    @place = current_user.places.find(params[:id])
    @owner = @place.user
  end
end
