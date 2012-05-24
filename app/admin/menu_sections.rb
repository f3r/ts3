ActiveAdmin.register MenuSection do
  
  filter :name
  
  controller do
  end
  
  show do |m|
    attributes_table do
      row :name    
      row :display_name
      row("Pages") do
         table_for(m.cmspage_menu_sections) do |t|
          t.column("") {|p| link_to p.cmspage, edit_admin_cmspage_path(p.cmspage)}
         end
      end
    end
  end
  
  form do |f|
    f.inputs do
      f.input :name
      f.input :display_name
      f.input :cmspages, :as => :check_boxes
    end
    f.buttons
  end
  
  collection_action :sort, :method => :post do
    params[:cmspage_menu_section].each_with_index do |id, index|
      CmspageMenuSection.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

end