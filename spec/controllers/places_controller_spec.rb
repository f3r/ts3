require 'spec_helper'

describe PlacesController do
  before(:each) do
    @user  = create(:user)
    @agent = create(:agent)
    @place = create(:place, :user => @agent)
  end

  it "won't allow Guest to see a place he doesn't own" do
    login_as @user
    expect {
      get :show, :id => @place.id
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
  
  it "won't allow Guest to edit a place he doesn't own" do
    login_as @user
    expect {
      get :wizard, :id => @place.id
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "shows my places" do
    login_as @agent
    get :index
    response.should be_success

    assigns(:results).count.should == 1
  end

  it "shows place preview to owner" do
    login_as @agent
    get :show, :id => @place.id
    response.should be_success

    assigns(:place).should == @place
  end
end
