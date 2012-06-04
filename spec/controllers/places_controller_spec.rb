require 'spec_helper'

describe PlacesController do
  before(:each) do
    @city = create(:city)
  end

  it 'shows places for a city' do
    get :index, :city => @city.slug
    response.should be_success
    assigns(:results).should_not be_empty
  end
end
