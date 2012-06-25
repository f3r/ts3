require 'spec_helper'

describe MenuSection do
  before(:each) do
    @menu_sections = MenuSection.create_defaults
  end
  
  it "check main not nil" do
    main = MenuSection.main
    main.should_not be_nil
  end
  
  it "check help not nil" do
    help = MenuSection.help
    help.should_not be_nil
  end
  
  it "check footer not nil" do
    footer = MenuSection.footer
    footer.should_not be_nil
  end
  
  it "no other menu section allowed" do
    #try to add another section
    menu_section = MenuSection.create(:name => "hOMe", :display_name => "HOME SECTION")
    menu_section.should_not be_persisted
  end
  
  it "adds a page to menusection" do
    page = FactoryGirl.create(:cmspage)
    page.external?.should be_false
    
    main = MenuSection.main
    main.cmspages << page
    main.cmspages.count.should == 1
    page.menu_sections.count.should == 1
  end
  
  it "adds a link to menusection" do
    link = FactoryGirl.create(:external_link)
    link.should be_persisted
    link.external?.should be_true
    
    main = MenuSection.main
    main.cmspages << link
    main.cmspages.count.should == 1
  end
  
  it "invalid link should not be persisted" do
    link = ExternalLink.create({:page_title => Faker::Name.name, :page_url => "invalid url"})
    link.should_not be_persisted
  end
  
  it "delete a page should delete its entry from menusection" do
    main = MenuSection.main
    footer = MenuSection.footer
    
    # Let's create a page
    page1 = FactoryGirl.create(:cmspage)
    
    main.cmspages << page1
    footer.cmspages << page1
    
    #Another page
    page2 = FactoryGirl.create(:cmspage)
    main.cmspages << page2
    
    #Now the count is 2
    main.cmspages.count.should == 2
    footer.cmspages.count.should == 1
    
    page1.destroy
    main.cmspages.count.should == 1
    
    footer.cmspages.count.should == 0
  end
  
end