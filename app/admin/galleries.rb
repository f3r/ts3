ActiveAdmin.register Gallery do
  menu :parent => 'CMS'
  filter :name

  controller do
    def update
      update! do |format|
          format.html { redirect_to admin_gallery_gallery_items_path(resource) }
        end
    end

    def show
      redirect_to admin_gallery_gallery_items_path(resource)
    end
  end

end