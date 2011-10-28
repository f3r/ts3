class PlacesController < ApplicationController
  layout 'plain'

  def new
    @place = Heypal::Place.new
  end

  def create
    @place = Heypal::Place.new(params[:place])
    if @place.save
      redirect_to wizard_place_path(@place)
    else
      render :action => :new
    end
  end

end
