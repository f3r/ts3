class AddLinkedFieldToCustomField < ActiveRecord::Migration
  def change
    add_column :custom_fields, :linked_field_id, :integer
  end
end
