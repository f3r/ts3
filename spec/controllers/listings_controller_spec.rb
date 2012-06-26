require 'spec_helper'

describe ListingsController do
  before(:each) do
    @agent  = create(:agent)
    login_as @agent
    SiteConfig.stub(:product_class).and_return(Service)
    @currency = create(:currency)
  end

  it "shows a form for a new listing" do
    get :new
    response.should be_success
    assigns(:resource).should be_instance_of(Service)
  end

  it "creates a new listing" do
    expect {
      post :create, :listing => attributes_for(:product)
    }.to change(Product, :count).by(1)
    response.should be_redirect
  end

  it "shows a wizard for completing a listing" do
    @service = create(:service, :user => @agent)
    get :edit, :id => @service.id
    response.should be_success
  end
  
  it "update the lat and lon when create a new listing" do
    Address.create!(
        :user_id => @agent.id,
        :street => 'Ayer Rajah',
        :city => 'Singapore',
        :country => 'SG',
        :zip => '1123'
      )
    @agent.address.should be_present
    expect {
      post :create, :listing => attributes_for(:product)
    }.to change(Product, :count).by(1)
    response.should be_redirect
  end
end
