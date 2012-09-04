ActiveAdmin.register CustomField  do
  menu :label => "Custom Fields", :parent => 'Settings', :if => lambda { |tabs| current_active_admin_user.super_admin? }

  config.clear_sidebar_sections!

  form do |f|
    f.inputs do
      f.input :name
      f.input :type_cd, :as => :select, :collection => CustomField.types, :include_blank => false
      f.input :required
      f.input :label
      f.input :hint
      f.input :validations
      f.input :values
      f.input :more_info_label, :hint => "Only valid with Yes_No_Text field"
    end
    f.buttons
  end
end
