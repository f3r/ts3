class CreatePaypalInfo < ActiveRecord::Migration
  def change
    create_table :paypal_auth_infos do |t|
      t.references :user
      t.string :email
      t.string :ppp_access_token
      t.string :ppp_access_token_verifier
      t.text   :personal_data_paypal_response
      t.text   :permissions_response
      t.timestamps
    end
  end
end
