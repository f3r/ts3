ActiveAdmin.register MenuSection do
  
  filter :name
  
  controller do
  end
  
  show do |m|
    attributes_table do
      row :name    
      row :display_name
      row("Pages") do
         table_for(m.cmspages) do |t|
          t.column("") {|p| link_to p, edit_admin_cmspage_path(p)}
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

end