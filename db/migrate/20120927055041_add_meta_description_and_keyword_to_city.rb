class AddMetaDescriptionAndKeywordToCity < ActiveRecord::Migration
  def change
    add_column :cities, :meta_description, :text
    add_column :cities, :meta_keywords, :text
    add_column :cities, :footer_seo_text, :text
  end
end
