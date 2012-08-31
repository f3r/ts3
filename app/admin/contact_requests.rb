ActiveAdmin.register ContactRequest do
  menu :priority => 6, :parent => 'E-Commerce'
  actions :index, :show

  scope :all, :default => true
  scope :active
  scope :inactive
  
  filter :name
  filter :email
  filter :created_at

  index do |contact|
    id_column
    column :name,   :sortable => :name
    column :email, :sortable => :email
    column :created_at
    column("Status")      {|contact| status_tag(contact.active ? 'Active' : 'Inactive') }
    default_actions
  end
end