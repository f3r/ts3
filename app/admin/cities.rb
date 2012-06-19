ActiveAdmin.register City do
  menu :parent => 'Settings'

  config.sort_order = 'position_asc'

  controller do
    helper 'admin/cities'
    def scoped_collection
      City.unscoped
    end
  end

  scope :all, :default => true
  scope :active
  scope :inactive

  filter :name
  filter :state
  filter :country
  filter :country_code, :as => :select, :collection => proc { City.select(["country_code as name"]).find(:all, :group => "country_code") }

  form do |f|
    f.inputs do
      f.input :name
      f.input :lat
      f.input :lon
      f.input :state
      f.input :country
      f.input :country_code
      f.input :active
    end
    f.buttons
  end

  index do
    id_column
    column :name
    column :state
    column :country
    column :country_code
    column("Status")      {|city| status_tag(city.active ? 'Active' : 'Inactive') }
    column("Actions")     {|city| city_links_column(city) }
  end

  collection_action :sort, :method => :post do
    params[:city].each_with_index do |id, index|
      City.update_all(['position=?', index+1], ['id=?', id])
    end
    delete_caches([
      "geo_cities_all_active", 
      "geo_cities_all", 
    ])
    render :nothing => true
  end

  # Activate/Deactivate
  action_item :only => :show do
    if city.active
      link_to 'Deactivate', deactivate_admin_city_path(city), :method => :put
    else
      link_to 'Activate', activate_admin_city_path(city), :method => :put
    end
  end
  
  member_action :activate, :method => :put do
    city = City.find(params[:id])
    activated = city.activate!
    redirect_to({:action => :show}, :notice => (activated ? "The city was activated" : "The city cannot be activated"))
  end
  
  member_action :deactivate, :method => :put do
    city = City.find(params[:id])
    activated = city.deactivate!
    redirect_to({:action => :show}, :notice =>"The city was deactivated")
  end
  
  sidebar "Translations", :only => :edit do
    div do
      b do
        resource.I18n_code
      end
    end
    table_for(Locale.all) do |t|
      t.column("Locale") {|v| v.code}
      t.column("Value") do |v| 
        key = Translation.where(:locale => v.code, :key => resource.I18n_code).first
        if key.nil?
          link_to "Create", new_admin_translation_path(:locale => v.code, :key => resource.I18n_code)
        else
          "#{key.value} #{link_to('Edit', redirect_edit_admin_translations_path(:locale => v.code, :key => resource.I18n_code))}".html_safe
        end
      end
    end
  end
  
end
