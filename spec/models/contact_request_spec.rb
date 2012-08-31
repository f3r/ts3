require 'spec_helper'

describe ContactRequest do
  before(:each) do
    @user = create(:user)
    @contactRequest = ContactRequest.create(:name => "Test", :email=>"test@test.com",:subject=>"Test Subject",:message => "Test Message")
  end
  
  it "check default contact status is true" do
    contact = ContactRequest.find_by_name("Test")
    contact.active.should == true
  end
  
  it "creating contact without name" do
    contact = ContactRequest.create( :email=>"test@test.com",:subject=>"Test Subject",:message => "Test Message")
    contact.should_not be_persisted
  end
  
  it "creating contact without email" do
    contact = ContactRequest.create( :name => "Test", :subject=>"Test Subject",:message => "Test Message")
    contact.should_not be_persisted
  end
  
  it "creating contact without subject" do
    contact = ContactRequest.create( :name => "Test", :email=>"test@test.com",:message => "Test Message")
    contact.should be_persisted
  end
  
  it "creating contact without message" do
    contact = ContactRequest.create( :name => "Test", :email=>"test@test.com",:subject=>"Test Subject")
    contact.should_not be_persisted
  end

end