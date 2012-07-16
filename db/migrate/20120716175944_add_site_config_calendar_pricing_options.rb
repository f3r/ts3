class AddSiteConfigCalendarPricingOptions < ActiveRecord::Migration
  def change
    add_column :site_configs, :calendar, :boolean, :default => true
    add_column :site_configs, :price_unit_id, :integer
  end
end
