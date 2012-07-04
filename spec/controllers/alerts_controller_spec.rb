require 'spec_helper'
describe AlertsController do
  before(:each) do
    @user = create(:user)
    @city = create(:city)
  end
  
  it "creates an alert" do
    login_as @user
    expect {
      post :create, :alert => {:schedule => "monthly", "delivery_method"=>"email", :query => {"city_id" => @city.id}}
    }.to change(Alert, :count).by(1)
  end
  
  it "soft deletes an alert" do
    login_as @user
    new_alert = @user.alerts.create(:schedule => "monthly", :delivery_method=>"email", :query => {"city_id" => @city.id})
    expect {
      put :destroy, :id => new_alert.id
    }.to change(Alert, :count).by(-1)
    
    new_alert.reload
    new_alert.deleted_at.should_not be_nil
  end
  
  it "pauses an alert" do
    login_as @user
    new_alert = @user.alerts.create(:schedule => "monthly", :delivery_method=>"email", :query => {"city_id" => @city.id})
    new_alert.active = true
    new_alert.save
    post :pause, :id => new_alert.id
    response.should be_redirect
    new_alert.reload
    new_alert.active.should == false
  end
  
  it "unpauses an alert" do
    login_as @user
    new_alert = @user.alerts.create(:schedule => "monthly", :delivery_method=>"email", :query => {"city_id" => @city.id})
    new_alert.active = false
    new_alert.save
    post :unpause, :id => new_alert.id
    response.should be_redirect
    new_alert.reload
    new_alert.active.should == true
  end
  
end