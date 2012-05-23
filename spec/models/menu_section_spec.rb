require 'spec_helper'

describe MenuSection do
  before(:each) do
    @menu_section = MenuSection.create(name: "Home", display_name: "Home")
  end
  
  it "finds menusection by name" do
    menu_section = MenuSection.find_by_name('home')
    menu_section.should_not be_nil
    
    #the name should go in downcase
    menu_section.name.should == "home"
  end
  
  it "menu section name should be unique" do
    #try to add another home section
    menu_section = MenuSection.create(:name => "hOMe", :display_name => "HOME SECTION")
    menu_section.should_not be_persisted
  end
  
  it "adds a page to menusection" do
    page = FactoryGirl.create(:cmspage)
    @menu_section.cmspages << page
    @menu_section.cmspages.count.should == 1
    page.menu_sections.count.should == 1
  end
  
  
end