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
    #Heypal::Place.update(params_with_token(:place))

    result = Heypal::Place.update(params_with_token(:place).merge(:id => params[:id]))

    logger.info('-------result')
    logger.info(result)

    #if result['stat'].eql?('fail')
      #errors = ''
      #result['err'].each_pair do |k, v|
        #errors += "$('##{k}_error').html('cant be blank');"
      #end
      #logger.info(errors)
      #render :js => errors unless errors.blank?
    #end
    render :text => "", :layout => false
  end

  def wizard
    @place = Heypal::Place.find(params[:id])
    @city = Heypal::Geo.find_by_city_id(@place.city_id)
  end

  def preview
    @place = Heypal::Place.find(params[:id])
    render(:template => 'places/preview')
  end

end
