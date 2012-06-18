ActiveAdmin.register SiteConfig, :as => 'Settings' do
  menu :label => "Config", :parent => 'Settings'

  controller do
    actions :index, :edit, :update

    def index
      redirect_to :action => :edit, :id => 1
    end

    def update
      update! do |format|
        format.html { redirect_to edit_resource_path(resource) }
      end
    end
  end

  form do |f|
    f.inputs "Basic Settings" do
      f.input :site_name
      f.input :site_url
      f.input :site_tagline
      f.input :mailer_sender
      f.input :support_email
      f.input :mail_bcc
      f.input :color_scheme, :as => :select, :collection => SiteConfig.color_schemes, :include_blank => false
    end

    f.inputs "Credentials for external services" do
      f.input :gae_tracking_code ,:label=>"Google Analytics Tracking Code"
      f.input :fb_app_id , :label=>"Facebook App ID"
      f.input :fb_app_secret, :label=>"Facebook Secret"
      f.input :tw_app_id, :label=>"Twitter App ID"
      f.input :tw_app_secret, :label=>"Twitter Secret"
    end

    f.inputs "SEO Enhancement" do
      f.input :custom_meta,
        :label => "Custom Meta Tags",
        :hint => "Please add with the format: <META NAME= \"Your Meta Tag Key\" content=\"Your Meta Tag Content\"> -- Please visit http://en.wikipedia.org/wiki/Meta_element for more info",
        :input_html => { :class => 'autogrow', :rows => 4, :cols => 20}
      f.input :meta_description, :hint => "Create a description of your site for search engines",
        :input_html => { :class => 'autogrow', :rows => 4, :cols => 20}
      f.input :meta_keywords, :hint => "Add all keywords that describe your site. Separated by commas",
        :input_html => { :class => 'autogrow', :rows => 4, :cols => 20}
    end

    f.inputs "Storage" do
      f.input :static_assets_path
    end

    f.buttons
  end
  
end