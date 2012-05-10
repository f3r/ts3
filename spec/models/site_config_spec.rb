require 'spec_helper'

describe SiteConfig do
  context "Singleton Behavior" do
    before(:each) do
      @site_config = SiteConfig.create(:id => 1, :site_name => 'SquareStays')
      SiteConfig.stub(:instance).and_return(@site_config)
    end

    it "returns the site_name" do
      SiteConfig.site_name.should == @site_config.site_name
    end
  end
end