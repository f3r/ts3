ActiveAdmin.register CustomField  do
  menu false

  form do |f|
    f.inputs do
      f.input :name
      f.input :type_cd, :as => :select, :collection => CustomField.types, :include_blank => false
      f.input :required
      f.input :label
      f.input :hint
      f.input :validations
      f.input :values
    end
    f.buttons
  end
end