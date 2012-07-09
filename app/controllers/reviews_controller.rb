class ReviewsController < PrivateController
  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.new(params[:review])
    @review.user = current_user

    @listing = @product.specific

    if @review.save
      flash[:notice] = 'Review submitted'
    else
      flash[:error] = 'There was an error submitting the review'
    end

    redirect_to seo_product_url(@listing)
  end
end
