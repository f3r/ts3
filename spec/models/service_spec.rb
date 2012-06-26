require 'spec_helper'

describe Service do
  pending "add some examples to (or delete) #{__FILE__}"
  
  it "update lat and lon" do
    @user = FactoryGirl.create(:user)
    @address = Address.create(
      :user_id => @user.id,
      :street => 'Ayer Rajah',
      :city => 'Singapore',
      :country => 'SG',
      :zip => '1123'
    )
    @currency = create(:currency)
    @service = create(:service, :user => @user)
    @service.lat.should_not be_nil
    @service.lon.should_not be_nil
  end
  
end
