class FavoritesController < PrivateController
  before_filter :find_parent

  def create
    @favorite = Favorite.new(:user_id => current_user.id)

    @favorite.favorable = @parent.product

    if @favorite.save
      find_parent # Reload the parent
      respond_to do |format|
        format.html { redirect_to seo_product_url(@parent), :flash => { :notice => t("favorites.messages.successfully_added_to_your_favorites") } }
        format.js { render :layout => false }
      end
    else
      render :text => 'error'
    end
  end

  def destroy
    @favorite = Favorite.where(:user_id => current_user.id, :favorable_id => @parent.product.id).first!

    if @favorite.destroy
      @remove_item = params[:remove_item] ||= false
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
    @parent = resource_class.published.find(params[:id])
  end
end
