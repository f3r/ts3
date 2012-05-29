ActiveAdmin.register ExternalLink  do
  menu false
  
  controller do
    actions :new, :create
    
   def create
    create! do |format|
        format.html { redirect_to admin_cmspages_path }
      end
   end
    
  end
  
  form do |f|
    f.inputs do
      f.input :page_title
      f.input :page_url , :label => "Page Url", :hint => "This link will be opened in new window in the front-end"
      f.input :active
    end
    f.buttons
  end
  
end