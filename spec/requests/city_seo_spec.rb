require 'spec_helper'

describe "City Seo" do
  before(:each) do
    SiteConfig.stub(:product_class).and_return(Property)
    SiteConfig.stub(:meta_description).and_return("SUPER DESCRIPTION")
    SiteConfig.stub(:meta_keywords).and_return("SUPER KEYWORD")
  end

  it "shows the city meta description, keyword" do
    city = create(:city, :name => "Singapore", :meta_description => "MY META", :meta_keywords => "MY KEYWORD")
    visit "/#{city.slug}"
    find('meta[name = "description"]')[:content].should == city.meta_description
    find('meta[name = "keywords"]')[:content].should == city.meta_keywords
  end

  it "shows the default city meta description, keyword" do
    city = create(:city, :name => "Singapore")
    visit "/#{city.slug}"
    find('meta[name = "description"]')[:content].should == "#{city.name} - #{SiteConfig.meta_description}"
    find('meta[name = "keywords"]')[:content].should == SiteConfig.meta_keywords
  end

  it "shows the footer seo" do
    city = create(:city, :name => "Singapore", :footer_seo_text => "THIS IS FOOTER SEO")
    visit "/#{city.slug}"
    page.should have_content(city.footer_seo_text)
  end
end