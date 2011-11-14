class PlacesController < ApplicationController
  layout 'plain'
  before_filter :login_required, :only => [:new, :wizard, :create]

  def new
    @place = Heypal::Place.new
  end

  def create
    place_params = params[:place]
    place_params[:access_token] = current_token

    @place = Heypal::Place.new(place_params)

    if @place.save
      redirect_to wizard_place_path(@place)
    else
      render :action => :new
    end
  end

  def update
    result = Heypal::Place.update(params_with_token(:place).merge(:id => params[:id]))
    render :text => "", :layout => false
  end

  def wizard
    @place = Heypal::Place.find(params[:id])
    @photos = @place.photos
    @availabilities = Heypal::Availability.find_all(:place_id => @place.to_param)
    #@city = Heypal::Geo.find_by_city_id(@place.city_id)
  end

  def preview
    @place = Heypal::Place.find(params[:id])
    @preview = true
    render(:template => 'places/show')
  end

  def show
    @place = Heypal::Place.find(params[:id])
    @preview = false
  end

  def photos
    @place = Heypal::Place.find(params[:id])
    @photos = @place.photos
    render :template => 'places/_photo_list', :layout => false
  end

  def upload_photo
    @place = Heypal::Place.find(params[:id])

    p = Heypal::Photo.new
    p.place_id = params[:id]
    p.photo_id = Time.now.to_i

    p.photo = params[:file]

    p.save

    photo = {
              :photo => {
                :id => p.photo_id,
                :name => '',
                :place_id => params[:id],
                :filename => params[:Filename],
                :large => p.photo.url(:large, false),
                :medium => p.photo.url(:medium, false),
                :small => p.photo.url(:small, false),
                :original => p.photo.url(:original, false)
              }
            }

    unless @place.photos.nil?
      @photos = @place.photos
    else
      @photos = []
    end

    @photos << photo

    post_params = {:photos => @photos.to_json}

    result = Heypal::Place.update(post_params.merge(:id => params[:id], :access_token => params[:token]))

    # Refresh (unnecessary since we can get it from the result object. But for the sake of testing today)

    @place = Heypal::Place.find(params[:id])
    @photos = @place.photos
    render :template => 'places/_photo_list', :layout => false

  end

  def get_cities
    @cities = Heypal::Geo.get_all_cities(params[:query])
    render :js => @cities.map.collect{|city| [city['name']]}
  end
end
