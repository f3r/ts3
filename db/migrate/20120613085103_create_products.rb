class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products, :as_relation_superclass => true do |t|
      t.references :user
      t.boolean    :published
      t.string     :title
      t.text       :description
      t.references :city
      t.string     :address_1, :address_2, :zip
      t.float      :lat, :long
      t.integer    :price

      t.timestamps
    end
  end
end
