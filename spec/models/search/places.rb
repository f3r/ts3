require 'spec_helper'

describe Search::Places do
  before(:each) do
    @user = create(:user)
    @search = Search::Places.new(@user, nil)
  end
  it "supports city_id" do
    @search.city_id = 1
    @search.city_id.should == 1
  end
end