require 'spec_helper'

describe SiteConfig do
  context "Singleton Behavior" do
    before(:each) do
      @site_config = SiteConfig.create!(:id => 1, :site_name => 'SquareStays')
    end

    it "returns the site_name" do
      SiteConfig.stub(:instance).and_return(@site_config)
      SiteConfig.site_name.should == @site_config.site_name
    end

    it "resets the cache when saving" do
      SiteConfig.site_name.should == @site_config.site_name
      @site_config.site_name = 'SquareNew'
      @site_config.save!

      SiteConfig.site_name.should == 'SquareNew'
    end
    
    it "set logo" do
      logo = File.open("#{Rails.root}/db/rake_seed_images/SquareStays.png")
      @site_config.logo = logo
      @site_config.save!
      SiteConfig.logo_file_name.should == 'SquareStays.png'
    end
    
  end
end