class PlacesController < PrivateController
  layout 'plain'
  before_filter :find_place, :only => [:wizard, :show, :update, :destroy, :photos, :update_currency, :publish_check, :publish, :unpublish]

  def index
    @results = current_user.places
  end

  def new
    @place = Place.new
  end

  def create
    place_params = params[:place]
    #place_params[:currency] = get_current_currency

    @place = Place.new(place_params)
    @place.user = current_user

    if @place.save
      redirect_to wizard_place_path(@place)
    else
      render :action => :new
    end
  end

  def update
    @place.attributes = params[:place]
    if @place.save
      response = {:stat => "ok", :place => @place}
    else
      err = format_errors(@place.errors.messages)
      response = {:stat => "fail", :err => err, :error_label => error_codes_to_messages(err).join(', ')}
    end
    render :json => response, :layout => false
  end

  def update_currency
    @place.attributes = params[:place]
    @place.save
    render :json => {:currency_sign => currency_sign_of(@place.currency)}
  end

  def publish
    if @place.publish!
      flash[:notice] = t("places.messages.place_published")
    else
      flash[:error] = t("places.messages.place_publish_error")
    end
    redirect_to place_path(:id => params[:id])
  end

  def unpublish
    @place.unpublish!
    flash[:notice] = t("places.messages.place_unpublished")
    redirect_to place_path(:id => params[:id])
  end

  def publish_check

    if @place.publish_check!
      response = {:stat => "ok"}
    else
      err = format_errors(@place.errors.messages)
      response = {:stat => "fail", :err => err, :error_label => error_codes_to_messages(err).join(', ')}
    end
    render :json => response, :layout => false
  end

  def wizard

    # filter data
  # @place_basic_info = @place
  # [:place_type, :user, :photos].each do |k|
  #   @place_basic_info[k] = nil
  # end

  # @photos = @place.photos
  # @availabilities = Heypal::Availability.find_all({:place_id => @place.to_param}, current_token)
    #@city = Heypal::Geo.find_by_city_id(@place.city_id)
  end

  def show
    @my_places = true

    render 'search/show'
  end

  def photos
    @photos = @place.photos
    render :template => 'places/_photo_list', :layout => false
  end

  def destroy
    if @place.delete
      flash[:notice] = t("places.messages.place_deleted")
    else
      flash[:error] = t("places.messages.place_deletion_error")
    end
    redirect_to my_places_path
  end

protected

  def find_place
    @place = Place.with_permissions_to(:manage).find(params[:id])
    @owner = @place.user
  end
end
