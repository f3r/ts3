require 'spec_helper'

describe "Show Place" do
  before(:each) do
    @agent    = create(:agent)
    @currency = create(:currency)
    @city     = create(:city, :name => "Singapore")
    @place    = create(:published_place, :user => @agent)
  end

  it 'shows other places for current place owner' do
    place2 = create(:published_place, :user => @agent)
    place3 = create(:published_place, :user => @agent)
    visit "/#{@city.slug}/#{@place.id}"
    page.should have_content(place2.title)
    page.should have_content(place3.title)
  end
end