class ImageCropperController < PrivateController

  def new
    @image_cropper = ImageCropper.new(:id_field => params[:id_field])
    respond_to do |format|
      format.js
    end
  end

  # def
  #   @user = current_user
  #   @image_cropper_uploader = ImageCropperUploader.retrieve_from_store!(@filename)
  # end

  def update
    @image_cropper = ImageCropper.get(params[:id])
    @image_cropper.attributes = params[:image_cropper]
    @image_cropper.image.recreate_versions!
    respond_to do |format|
      format.js
    end
  end

  def create
    begin
      @image_cropper = ImageCropper.new(params[:image_cropper])
    rescue CarrierWave::IntegrityError
      @image_cropper = ImageCropper.new
    end
    @image_cropper.save
    respond_to do |format|
      format.js
    end
  end

end