ActiveAdmin.register Payment do
  menu false
  config.clear_sidebar_sections!

  index do |place|
    id_column
    column :recipient
    column :amount
    column :pay_at
    default_actions
  end
end