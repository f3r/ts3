class PhotosController < ApplicationController
  respond_to :js

  before_filter :authenticate_user!, :except => [:create]
  before_filter :find_parent

  def create
    @photo = @parent.photos.new(:photo => params[:photo])
    @photo.save
    @photos = @parent.photos

    render :partial => 'photos/list', :layout => false
  end

  def destroy
    @photo = @parent.photos.find(params[:id])
    @photo.destroy
    @place = @parent.reload
    @published = @place.published

    respond_to do |format|
      format.js{ render :template => 'photos/destroy', :layout => false }
    end
  end

  def sort
    @parent.photos.set_positions(params[:photo_ids])

    respond_to do |format|
      format.js{ render :template => 'photos/sort', :layout => false }
    end
  end

  # def update
  #   Heypal::Photo.update(params[:place_id], params[:id], {:name => params[:name]}, current_token)
  #   respond_to do |format|
  #     format.js{ render :template => 'photos/update.js.erb', :layout => false }
  #   end
  # end

  protected

  def find_parent
    @parent = Place.with_permissions_to(:read).find(params[:place_id])
  end
end
