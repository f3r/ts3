class AddHomeSectionToMenuSections < ActiveRecord::Migration
  def change
    MenuSection.create(:name => "home", :display_name => "Home")
  end
end
