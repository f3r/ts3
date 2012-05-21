class AddRouteAsToCmspage < ActiveRecord::Migration
  def self.up
    add_column :cmspages, :route_as, :string
  end
  
  def self.down
    remove_column :cmspages, :route_as
  end

end
