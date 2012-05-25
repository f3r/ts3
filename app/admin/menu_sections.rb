ActiveAdmin.register MenuSection do
  
  filter :name
  
  controller do
  end
  
  index do
    id_column
    column :name
    column 'Type', :sortable => false  do 
      |m| m.menu_types[m.mtype] 
      end
    column 'Location', :sortable => false  do
      |m| m.menu_locations[m.location] 
      end
    column :created_at 
    default_actions
  end
  
  
  show do |m|
    attributes_table do
      row :name    
      row :display_name
      row("Type") do  
         m.menu_types[m.mtype]
      end
      row("Location") do  
         m.menu_locations[m.location]
      end
      
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
      f.input :mtype, :as => :select, :collection => {"Inline" => "1", "Dropdown" => "2"}, :hint => "If type is 'Inline', the first page's title will be used as the menu title else the 'display name'"
      f.input :location, :as => :select, :collection => {"Left" => "1", "Right" => "2"}
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