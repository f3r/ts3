class PhotosController < ApplicationController
  layout 'plain'
  #before_filter :login_required
  before_filter :find_place

  def create
    Heypal::Photo.create(@place.id, params[:file], params[:token])

    @place = Heypal::Place.find(params[:id], current_token)
    @photos = @place.photos
    render :template => 'places/_photo_list', :layout => false
  end
  
  def destroy
    #Heypal::Photo.delete(params[:id], current_token)
    respond_to do |format|
      format.js{ render :template => 'photos/destroy.js.erb', :layout => false }
    end
  end
  
protected

  def find_place
    @place = Heypal::Place.find(params[:place_id], current_token)
  end
end
