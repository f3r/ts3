class AddPriceUnitToUserPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :price_unit, :string
  end
end
