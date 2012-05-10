require 'spec_helper'

describe Heypal::User, :backend => true do

  it "should be able to sign up on the site using my email and password" do
    @user = Heypal::User.create(:name => 'test', :email => 'test@test.com', :password => 'hello123')

    @user.should be_success
  end

  it "should be to confirm my account after registration" do
    Heypal::User.confirm(:confirmation_token => '12312312').should == true
  end

  it "should be able to resend confirmation" do
    Heypal::User.resend_confirmation(:email => 'someemail@email.com').should == true
  end

  it "should be able to reset password" do
    Heypal::User.reset_password(:email => 'someemail@email.com').should == true
  end

  it "should be able to confirm password reset" do
    Heypal::User.confirm_reset_password(:email => 'someemail@email.com').should == true
  end

end
