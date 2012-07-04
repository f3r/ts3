require 'spec_helper'

describe Service do
  it "retrieves lat and lon from the user profile" do
    @user = create(:user)
    # Mock the geocode method so lat/lon are set upon address save
    @address = build(:address, :user => @user)
    @address.should_receive(:geocode) do |arg|
      @address.lat = 1.672672762676
      @address.lon = 2.981728727261
    end
    @address.save

    @service = create(:service, :user => @user)

    @service.lat.should == @address.lat
    @service.lon.should == @address.lon
  end

end