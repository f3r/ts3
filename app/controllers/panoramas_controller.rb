class PanoramasController < PrivateController
  layout 'plain'

  def new
    respond_to do |format|
      format.js{ render :template => 'panoramas/new.js.erb', :layout => false }
    end
  end

  def create
    @resource = resource_class.manageable_by(current_user).find(params[:listing_id])
    @product = @resource.product

    panorama_params = params[:panorama]

    if panorama_params && panorama_params[:xml].respond_to?(:read)
      panorama_params[:xml] = panorama_params[:xml].read
    end

    @panorama = @product.panoramas.create(panorama_params)

    render :text => 'ok'
  end
end
