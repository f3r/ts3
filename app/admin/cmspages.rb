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
      f.input :page_url , :label => "Page Url", :hint => "Ex: if page url is how , the original url like Siteurl/page/how"
      f.input :description ,:input_html => {:class => 'tinymce'}
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
  
  # Activate/Deactivate
  action_item :only => :show do
    if cmspage.active
      # link_to 'Deactivate', deactivate_admin_cmspage_path(cmspage),  :method => :put
    else
      # link_to 'Activate',   deactivate_admin_cmspage_path(cmspage),   :method => :put
    end
  end

  #   # Make Agent
  # action_item :only => :show do
  #   link_to('Make Agent', make_agent_admin_user_path(user), :method => :put, 
  #     :confirm => 'Are you sure you want to turn the user into an agent?') if user.consumer?
  # end
  
  # member_action :make_agent, :method => :put do
  #   user = User.find(params[:id])
  #   user.update_attribute(:role, 'agent')
  #   redirect_to({:action => :show}, :notice => "The user is now an agent")
  # end
  
end
