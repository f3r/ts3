class AddTypeAndPostitionToMenuSection < ActiveRecord::Migration
  def change
    add_column :menu_sections, :mtype, :tinyint, :default => 1
    ##
    # Menutype mtype can take 1 => Inline, 2 => Dropdown
    ##
    add_column :menu_sections, :location, :tinyint, :default => 1
    ##
    # Menulocation location can take 1 => left, 2 => right
    ##
  end
end
