ActiveAdmin.register Cmspage  do

  controller do
    actions :all, :except => [:show]
  end

  menu     :priority => 9, :label => "Pages"
  
  config.sort_order = 'id_asc'
  
  scope :all, :default => true
  scope :active
  scope :inactive

  filter :page_title
  
  controller do
    helper 'admin/cmspages'
    
    def destroy
      if resource.mandatory?
        redirect_to admin_cmspage_path, :notice => "Page not deletable"
      else
        super
      end
    end
  end
  
  form do |f|
    f.inputs do
      f.input :page_title
      f.input :page_url , :label => "Page Url", :hint => cmspage.external? ? "This link will be opened in new window in the front-end" : "Ex: if page url is how , the original url like Siteurl/page/how"
      unless cmspage.external? #We don't need the description editor for externallinks
        f.input :description ,:input_html => {:class => 'tinymce'}
      end
      f.input :active
    end
    f.buttons
  end
  
  index do
    id_column
    column :page_title
    column :page_url
    column("description")  {|cmspage| truncate(cmspage.description)}
    column("Status")       {|cmspage| status_tag(cmspage.active ? 'Active' : 'Inactive') }
    default_actions(:name => 'Actions')
  end
  
  action_item  do
      link_to 'New External Link', new_admin_external_link_path
  end

end
