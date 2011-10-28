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
      render :text => @place.inspect
      redirect_to wizard_place_path(@place)
    else
      render :action => :new
    end

  end

end
