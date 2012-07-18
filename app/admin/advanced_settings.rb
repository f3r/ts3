ActiveAdmin.register SiteConfig, :as => 'Advanced Settings' do
  menu false

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
  	f.inputs "Advanced Settings" do
  	  f.input :color_scheme, :as => :select, :collection => SiteConfig.color_schemes, :include_blank => false
  	  #f.input :fee_amount
  	  #f.input :charge_total
  	  #f.input :fee_is_fixed
  	  f.input :calendar, :hint => '(Show calendar tab and availability management)'
    end
    f.inputs "Pricing Units" do
      f.input :enable_price_sale
      f.input :enable_price_per_month
      f.input :enable_price_per_week
      f.input :enable_price_per_day
      f.input :enable_price_per_hour
    end
    f.buttons
  end
end