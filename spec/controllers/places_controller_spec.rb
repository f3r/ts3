require 'spec_helper'

describe PlacesController do
  before(:each) do
    @user  = create(:user)
    @agent = create(:agent)
    @city = create(:city)
    @place_type = create(:place_type)
  end

  context "Creation" do
    it "creates a place" do
      login_as @agent
      expect {
        post :create, :place => attributes_for(:place, :city_id => @city.id, :place_type_id => @place_type.id)
        response.should be_redirect
      }.to change(Place, :count).by(1)
    end

    it "doens't create a place with validation errors" do
      login_as @agent
      expect {
        post :create, :place => attributes_for(:place, :title => nil, :city_id => @city.id, :place_type_id => @place_type.id)
        response.should be_success
      }.to_not change(Place, :count)

      assigns(:place).errors_on(:title).should be_true
    end
  end

  context "Wizard" do
    before(:each) do
      @place = create(:place, :user => @agent)
    end

    it "won't allow Guest to edit a place he doesn't own" do
      login_as @user
      expect {
        get :wizard, :id => @place.id
      }.to raise_error(Authorization::NotAuthorized)
    end
  end

  context "Management" do
    before(:each) do
      @place = create(:place, :user => @agent)
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

    it "won't allow Guest to see a place he doesn't own" do
      login_as @user
      expect {
        get :show, :id => @place.id
      }.to raise_error(Authorization::NotAuthorized)
    end

    it "deletes a place" do
      login_as @agent
      expect {
        post :destroy, :id => @place.id
        response.should be_redirect
      }.to change(Place, :count).by(-1)
    end

    it "cannot delete somebody elses place" do
      login_as @user
      expect {
        post :destroy, :id => @place.id
      }.to raise_error(Authorization::NotAuthorized)
    end
  end
end
