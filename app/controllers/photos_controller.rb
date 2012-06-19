class PhotosController < ApplicationController
  respond_to :js

  before_filter :authenticate_user!, :except => [:create]
  before_filter :find_parent, :except => [:create]

  def create
    @place = @resource = Place.find(params[:place_id])
    @photo = @resource.photos.new(:photo => params[:file])
    @photo.save
    @photos = @resource.photos

    render :partial => 'photos/list', :layout => false
  end

  def destroy
    @photo = @resource.photos.find(params[:id])
    @photo.destroy
    @place = @resource.reload
    @published = @resource.published

    respond_to do |format|
      format.js{ render :template => 'photos/destroy', :layout => false }
    end
  end

  def sort
    @resource.photos.set_positions(params[:photo_ids])

    respond_to do |format|
      format.js{ render :template => 'photos/sort', :layout => false }
    end
  end

  def update
    @photo = @resource.photos.find(params[:id])
    @photo.name = params[:name]
    @photo.save
    respond_to do |format|
      format.js{ render :template => 'photos/update', :layout => false }
    end
  end

  protected

  def find_parent
    @resource = Place.with_permissions_to(:read).find(params[:place_id])
  end
end
