require 'spec_helper'

describe ProfilesController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_as @user
  end

  context "Information" do
    it "shows user profile" do
      get :show
      response.should be_success
      assigns(:user).should == @user
    end

    it "show user profile edit page" do
      get :edit
      response.should be_success
      assigns(:user).should == @user
    end

    it "updates the user information" do
      post :update, :user => {
        :first_name => 'First Name'
      }
      response.should be_redirect
      @user.reload
      @user.first_name.should == 'First Name'
    end
  end

  context "Address" do
    it "stores the user address" do
      post :update, :user => {
        :address_attributes => {
          :street => 'Ayer Rajah',
          :city => 'Singapore',
          :country => 'SG',
          :zip => '1123'
        }
      }
      response.should be_redirect
      @user.reload
      address = @user.address
      address.should_not be_nil
      address.street.should == 'Ayer Rajah'
    end

    it "updates the user address" do
      Address.create!(
        :user_id => @user.id,
        :street => 'Ayer Rajah',
        :city => 'Singapore',
        :country => 'SG',
        :zip => '1123'
      )
      @user.address.should be_present

      post :update, :user => {
        :address_attributes => {
          :zip => '2323'
        }
      }
      response.should be_redirect
      @user.reload
      address = @user.address
      address.zip.should == '2323'
    end
    
    it "create the lat and lon" do
      post :update, :user => {
        :address_attributes => {
          :street => 'Trivandrum',
          :city => 'Trivandrum',
          :country => 'India',
          :zip => '1123'
        }
      }
      @user.address.should be_present
      @user.reload
      address = @user.address
      address.should_not be_nil
      address.lat.should_not be_nil
      address.lon.should_not be_nil
    end
    
    it "updates lat and lon when the user updates the address" do
      Address.create!(
        :user_id => @user.id,
        :street => 'Ayer Rajah',
        :city => 'Singapore',
        :country => 'SG',
        :zip => '1123'
      )
      @user.address.should be_present
      createdaddress = @user.address

      post :update, :user => {
        :address_attributes => {
          :street => 'Trivandrum',
          :city => 'Trivandrum',
          :country => 'India',
        }
      }
      response.should be_redirect
      @user.reload
      address = @user.address
      address.lat.should_not == createdaddress.lat
      address.lon.should_not == createdaddress.lon
    end
    
  end

  context "Password" do
    it "changes the user password" do
      post :update, :user => {
        :password => 'secret',
        :password_confirmation => 'secret'
      }
      response.should be_redirect
      @user.reload
      @user.should be_valid_password('secret')
    end

    it "doesn't change the password without correct confirmation" do
      post :update, :user => {
        :password => 'secret',
        :password_confirmation => 'sercet'
      }
      response.should be_success
      @user.reload
      @user.should_not be_valid_password('secret')
    end
  end
end
