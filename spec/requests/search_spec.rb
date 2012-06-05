require 'spec_helper'

describe "Search" do
  before(:each) do
    City.create(name: "Singapore", lat: 1.28967, lon: 103.85, country: "Singapore", country_code: "SG", active: true)
  end

  it "recognizes city seo url" do
    assert_routing({ :path => "/singapore", :method => :get },
      { :controller => 'search', :action => 'index', :city => 'singapore' })
  end

end
