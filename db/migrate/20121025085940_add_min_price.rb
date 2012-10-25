class AddMinPrice < ActiveRecord::Migration
  def change
    add_column :site_configs, :min_price, :integer
  end
end
