require 'spec_helper'

describe "Search" do
  before(:each) do
    @city = create(:city, :name => "Singapore")
  end

  it "recognizes city seo url" do
    assert_routing({ :path => "/singapore", :method => :get },
      { :controller => 'search', :action => 'index', :city => 'singapore' })
  end

  it "recognizes place seo url" do
    assert_routing({ :path => "/singapore/23-nice-house", :method => :get },
      { :controller => 'search', :action => 'show', :city => 'singapore', :id => '23-nice-house' })
  end

  context "Place Results/Details" do
    before(:each) do
      create(:currency)
      @place = create(:published_place, :city => @city)
    end

    it 'shows places for a city' do
      visit '/singapore'
      page.should have_content(@place.title)
    end

    it 'shows the details for a place' do
      visit "/singapore/#{@place.id}"
      page.should have_content(@place.title)
    end
  end

end
