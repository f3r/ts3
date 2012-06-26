require 'spec_helper'

describe "Places Management" do
  before(:each) do
    @agent    = create(:agent)
    @currency = create(:currency)
    @city     = create(:city, :name => "Singapore")
    @place    = create(:published_place, :user => @agent)
    SiteConfig.stub(:product_class).and_return(Property)
  end

  def login_as(user)
    visit '/users/login'
    fill_in 'user[email]',    :with => @agent.email
    fill_in 'user[password]', :with => @agent.password
    click_button 'Login'
  end

  it 'shows places for a city' do
    login_as @agent
    visit '/listings'
    page.should have_content(@place.title)
  end
end