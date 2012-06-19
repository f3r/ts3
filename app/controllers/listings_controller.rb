class ListingsController < PrivateController
  layout 'plain'
  before_filter :find_resource, :only => [:wizard, :show, :edit, :update, :update_currency, :destroy, :publish, :unpublish]

  def index
    @collection = resource_class.manageable_by(current_user)
  end

  def new
    @resource = resource_class.new
  end

  def create
    @resource = resource_class.new(params[:listing])
    @resource.user = current_user

    if @resource.save
      redirect_to edit_listing_path(@resource)
    else
      render :action => :new
    end
  end

  def show
    @my_products = true

    render 'search/show'
  end

  def edit
    render 'places/wizard'
  end

  def update
    @resource.attributes = params[:listing]
    if @resource.save
      response = {:stat => "ok", :place => @resource}
    else
      err = format_errors(@resource.errors.messages)
      response = {:stat => "fail", :err => err, :error_label => error_codes_to_messages(err).join(', ')}
    end
    render :json => response, :layout => false
  end

  def update_currency
    @resource.attributes = params[:listing]
    @resource.save
    render :json => {:currency_sign => currency_sign_of(@resource.currency)}
  end

  def destroy
    if @resource.delete
      flash[:notice] = t("products.messages.listing_deleted")
    else
      flash[:error] = t("products.messages.listing_deletion_error")
    end
    redirect_to listings_path
  end

  def publish
    if @resource.publish!
      flash[:notice] = t("places.messages.place_published")
    else
      flash[:error] = t("places.messages.place_publish_error")
    end
    redirect_to listing_path(@resource)
  end

  def unpublish
    @resource.unpublish!
    flash[:notice] = t("places.messages.place_unpublished")
    redirect_to listing_path(@resource)
  end

  protected

  def find_resource
    @resource = collection.find(params[:id])
    @owner = @resource.user
  end

  def collection
    resource_class.manageable_by(current_user)
  end

  def resource_class
    SiteConfig.product_class
  end
end