class FavoritesController < ApplicationController
  before_filter :find_parent

  def create
    @favorite = Favorite.new(:user_id => current_user.id)

    @favorite.favorable = @parent

    if @favorite.save
      find_parent # Reload the parent
      respond_to do |format|
        format.html { redirect_to place_path(@place['id']), :flash => { :notice => t(:successfully_added_to_your_favorites) } }
        format.js { render :layout => false }
      end
    else
      render :text => 'error'
    end
  end

  def destroy
    @favorite = Favorite.where(:user_id => current_user.id, :favorable_id => params[:id]).first!

    if @favorite.destroy
      find_parent # Reload the parent
      respond_to do |format|
        format.js { render :layout => false }
      end
    else
      render :text => 'not ok'
    end
  end

private

  def find_parent
    @parent = @place = Heypal::Place.find(params[:place_id], current_token)
  end
end
