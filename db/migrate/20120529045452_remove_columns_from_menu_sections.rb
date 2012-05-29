class RemoveColumnsFromMenuSections < ActiveRecord::Migration
  def up
    remove_column :menu_sections, :location
    remove_column :menu_sections, :mtype
  end
  
  def down
    add_column :menu_sections, :mtype, :tinyint, :default => 1
    add_column :menu_sections, :location, :tinyint, :default => 1
  end
end
