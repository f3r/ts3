require 'spec_helper'

describe Address do
  before(:each) do
    @user = create(:user)
    @address = build(:address, :user => @user)
  end

  it "geolocalizes the address" do
    @address.should_receive :geocode
    @address.bussiness_address.should be_present
    @address.save
  end

  it "updates product's lat and lon when the user updates the address" do
    @address.stub(:geocode) do |arg|
      @address.lat = 1.672672762676
      @address.lon = 2.981728727261
    end
    @service1 = create(:service, :user => @user)
    @service2 = create(:service, :user => @user)
    @address.save

    [@service1, @service2].each do |s|
      s.reload
      s.lat.should == @address.lat
      s.lon.should == @address.lon
    end
  end
end