class CreatePayment < ActiveRecord::Migration
  def change
    create_table :payments do |t|      
      t.integer    :amount
      t.text       :note
      t.references :recipient
      t.references :transaction
      t.string     :state
      t.datetime   :added_at
      t.timestamps
    end
  end
end
