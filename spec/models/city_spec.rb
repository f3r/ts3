require 'spec_helper'

describe City do
  before(:each) do
    City.create(name: "Singapore", lat: 1.28967, lon: 103.85, country: "Singapore", country_code: "SG", active: true )
  end

  it "finds cities by name" do
    city = City.find('singapore')
    city.should_not be_nil
    city.code.should == :singapore
  end
end