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
    
    def new
      unless params[:frommenu].nil?
        session[:frommenu] = params[:frommenu]
      end
      new!
    end
    
    def create
      create! do |format|
        frommenu = session[:frommenu]
        format.html do
          if frommenu.nil?
            super
          else
            session[:frommenu] = nil
            resource.active = true
            resource.save
            session[:newlink] = resource
            redirect_to admin_menu_section_path(frommenu)
          end
        end
      end
    end
    
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
      f.input :page_url , :label => "Page Url", :hint => cmspage.external? ? "This link will be opened in new window" : "Ex: if page url is 'how', the final url would be #{SiteConfig.site_url}/page/how"
      unless cmspage.external? #We don't need the description editor for externallinks
        f.input :description ,:input_html => {:class => 'tinymce'}
      end
      f.input :meta_keywords
      f.input :meta_description
      f.input :active
    end
    f.buttons
  end
  
  index do
    id_column
    column :page_title
    column :page_url
    column("description")  {|cmspage| truncate(cmspage.description)}
    column :meta_keywords
    column :meta_description
    column("Status")       {|cmspage| status_tag(cmspage.active ? 'Active' : 'Inactive') }
    default_actions(:name => 'Actions')
  end
  
  action_item  do
      link_to 'New External Link', new_admin_external_link_path
  end

end
