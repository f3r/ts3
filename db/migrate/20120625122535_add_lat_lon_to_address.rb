class AddLatLonToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :lat,   :double
    add_column :addresses, :lon,   :double
  end
end
