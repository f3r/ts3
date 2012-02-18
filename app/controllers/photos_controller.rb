class PhotosController < ApplicationController
  layout 'plain'
  before_filter :login_required, :except => [:create]
  before_filter :find_place, :except => [:create]

  def create
    Heypal::Photo.create(@place.id, params[:file], params[:token])

    @place = Heypal::Place.find(@place.id, params[:token])
    @photos = @place.photos
    render :template => 'places/_photo_list', :layout => false
  end
  
  def destroy
    Heypal::Photo.delete(params[:id], current_token)
    respond_to do |format|
      format.js{ render :template => 'photos/destroy.js.erb', :layout => false }
    end
  end
  
  def sort
    Heypal::Photo.sort(@place.id, params[:photo_ids], current_token)
    respond_to do |format|
      format.js{ render :template => 'photos/destroy.js.erb', :layout => false }
    end
  end
  
  def update
    Heypal::Photo.update(params[:place_id], params[:id], {:name => params[:name]}, current_token)
    respond_to do |format|
      format.js{ render :template => 'photos/update.js.erb', :layout => false }
    end
  end
  
protected

  def find_place
    @place = Heypal::Place.find(params[:place_id], params[:token])
  end
end
