require 'spec_helper'

describe FavoritesController do
  before(:each) do
    @user = double("user", :id => 32)
    session['current_user'] = @user

    Heypal::Place.stub(:find).and_return(double(:id => 1))
  end

  it "creates a new favorite" do
    lambda {
      post :create, :place_id => 23
    }.should change(Favorite, :count).by(1)
  end

  it "removes a favorite" do
    fav = FactoryGirl.create(:favorite, :user_id => @user.id)
    lambda {
      delete :destroy, :id => fav.favorable_id, :place_id => fav.favorable_id
    }.should change(Favorite, :count).by(-1)
  end

  it "doesn't remove another user favorite" do
    fav = FactoryGirl.create(:favorite, :user_id => @user.id + 1)
    lambda {
      delete :destroy , :id => fav.id, :place_id => fav.favorable_id
    }.should raise_error
  end
end
