class AvailabilitiesController < ApplicationController
  before_filter :login_required

  def create
    place = Heypal::Place.find(params[:place_id])
    puts params.inspect
    puts 'I just got here you know'
    respond_to do |format|
      format.json { render :json => place }
    end
  end
end
