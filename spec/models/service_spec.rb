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

  it "assings multiple languages" do
    @service = build(:service)
    @service.language_ids = [0, 1]
    @service.language_1_cd.should == 0
    @service.language_2_cd.should == 1
  end

  it "deletes product when deleting the service" do
    @service = create(:service)

    expect {
      @service.destroy
    }.to change(Product, :count).by(-1)
  end
end