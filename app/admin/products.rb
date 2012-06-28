klass = SiteConfig.product_class

ActiveAdmin.register klass do
  menu :priority => 1, :parent => 'E-Commerce'

  scope :all, :default => true
  scope :published
  scope :unpublished
  
  filter :title
  filter :user
  filter :city
  filter :created_at
  
  controller do
    helper 'admin/products'
  end
  
  
  index do
    id_column
    column :title
    column :user
    column :city
    column :created_at
    column :updated_at
    column("Status")      {|p| status_tag(p.published ? 'Published' : 'Unpublished') }
    default_actions(:name => 'Actions')
  end
  
  show do
    resource_super_class_rows = resource.product.class.columns.collect{|column| column.name.to_sym }
    resource_super_class_rows = resource_super_class_rows.reject{|c| c =~ /id|created_at|updated_at|as_product_type/}
    rows = [:id] + resource_super_class_rows + default_attribute_table_rows.reject{|c| c =~ /id/}
    attributes_table *rows do
      row(:photos) {|p| product_photos_row(p)}            
    end
    active_admin_comments
  end
  
  form :partial => "form"
  
end
