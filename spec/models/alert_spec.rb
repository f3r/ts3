require 'spec_helper'
describe Alert do
  before(:each) do
    @user = create(:user)
  end
  
  it "creates saves an alert" do
    new_alert = @user.alerts.create(:schedule => "monthly", :query => {'test'=>'test'})
    new_alert.should be_persisted
    new_alert.search_code.should_not be_nil
    new_alert.alert_type.should == SiteConfig.product_name
  end
  
end