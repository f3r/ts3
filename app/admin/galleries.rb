ActiveAdmin.register Gallery do
  
  show :title => :name do
    panel "Gallery Items" do
      table_for gallery.gallery_items do |t|
        t.column :link
        t.column :label
        t.column("IMAGE") do |fc|
           image_tag(fc.photo.url("tiny"))
        end
        t.column("Visible") do |fc|
           status_tag(fc.active ? 'Yes' : 'No')
        end 
        t.column :created_at
        t.column do |fc| 
          link_to("Details", admin_gallery_item_path(fc)) + " | " + \
          link_to("Edit", edit_admin_gallery_item_path(fc)) + " | " + \
          link_to("Delete", admin_gallery_item_path(fc), :method => :delete, :confirm => "Are you sure?")
        end
      end
    end
  end
  
  action_item :only => :show do
    link_to "Add Photos", add_photos_admin_gallery_path(resource)
  end
  
  member_action :add_photos do
    config.clear_action_items
    @gallery = Gallery.find(params[:id])
  end
  
  member_action :add_photo, :method => :post do
    config.clear_action_items
    @gallery = Gallery.find(params[:id])
    gallery_item = @gallery.gallery_items.new(:photo => params[:Filedata])
    gallery_item.save!
    render :nothing => true
  end
  

end