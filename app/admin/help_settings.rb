ActiveAdmin.register Faq, :as => 'Help Settings' do
  menu :label => "Manage Help settings", :parent => 'Settings', :if => lambda { |tabs| current_active_admin_user.super_admin? }
  
  controller do
    def action_methods
      if current_admin_user.super_admin?
        super
      else
         {}
      end
    end
  end
  
  config.sort_order = 'id_asc'

  scope :all, :default => true

  filter :title
  
  index do
    id_column
    column :title
    column :content
    default_actions
  end
end
