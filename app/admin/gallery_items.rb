ActiveAdmin.register GalleryItem  do
  menu false
  
  controller do
    actions :edit, :update, :destroy, :show
    
    def update
      update! do |format|
        format.html { redirect_to admin_gallery_path(resource.gallery) }
      end
    end
    
    def destroy
      destroy! do |format|
        format.html { redirect_to admin_gallery_path(resource.gallery) }
      end
    end
  end
  
  show do |gi|
    attributes_table do
      row :id    
      row :link
      row :label
      row("IMAGE") do
         image_tag(gi.photo.url)
      end
      row("Visible") do
         status_tag(gi.active ? 'Yes' : 'No')
      end 
      row :created_at
    end
  end  
  
  form do |f|
    f.inputs do
      f.input :link
      f.input :label
      f.input :photo
      f.input :active, :label => "Visible?"
    end
    f.buttons
  end
  
end
