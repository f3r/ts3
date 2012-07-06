require 'spec_helper'

describe ListingsController do
  before(:each) do
    @agent  = create(:agent)
    login_as @agent
    SiteConfig.stub(:product_class).and_return(Service)
    @currency = create(:currency)
    @city = create(:city)
  end

  it "shows a form for a new listing" do
    get :new
    response.should be_success
    assigns(:resource).should be_instance_of(Service)
  end

  it "creates a new listing" do
    expect {
      post :create, :listing => attributes_for(:product, :city_id => @city.id)
    }.to change(Product, :count).by(1)
    response.should be_redirect
  end

  it "shows a wizard for completing a listing" do
    @service = create(:service, :user => @agent)
    get :edit, :id => @service.id
    response.should be_success
  end

  it "updates the user address" do
    @service = create(:service, :user => @agent)
    put :update_address,
      :id => @service.id,
      :user => {
        :address_attributes => {
          :street => 'Ayer Rajah',
          :city => 'Singapore',
          :country => 'SG',
          :zip => '1123'
        }
      }

    response.should be_redirect
    @agent.reload
    @agent.address.should_not be_nil
    @agent.address.street.should == 'Ayer Rajah'
  end

  it "limits the number of listings" do
    get :new
    response.should be_success

    @service = create(:service, :user => @agent)
    get :new
    response.should redirect_to(edit_listing_path(@service))
  end
end
