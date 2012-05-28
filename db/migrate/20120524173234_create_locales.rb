class CreateLocales < ActiveRecord::Migration
  def change
    create_table :locales do |t|
      t.string :code
      t.string :name
      t.string :name_native
      t.integer :position
      t.boolean :active, :default => false
    end
    add_index :locales, [:code], :unique => true
    
  end
end
