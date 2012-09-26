class CreateAdminFaqTable < ActiveRecord::Migration
  def connection
    ActiveRecord::Base.establish_connection("tse_admin_faq_#{Rails.env}".to_sym).connection
  end

  def change
    create_table :faqs do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
    ActiveRecord::Base.establish_connection("#{Rails.env}").connection
  end
end
