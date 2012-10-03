ActiveAdmin.register DjClub do
  menu :parent => 'CMS'
  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :address
      f.input :location
      f.input :email
      f.input :phone
      f.input :website
      f.input :photo1
    end
    f.buttons
  end
end