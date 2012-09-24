require 'spec_helper'

describe InquiriesController do
  before(:each) do
    @place = create(:published_place)
    SiteConfig.stub(:product_class).and_return(Property)
  end

  it "sends an inquiry for a registered user" do
    @user = create(:user)
    login_as @user

    Inquiry.any_instance.stub(:spam?).and_return(false)
    expect {
      xhr :post, :create, inquiry_params.merge(:id => @place.id)
    }.should change(Inquiry, :count).by(1)
  end

  it "amend multiple inquries for a registered user" do
    @user = create(:user)
    login_as @user

    Inquiry.any_instance.stub(:spam?).and_return(false)
    expect {
      xhr :post, :create, inquiry_params.merge(:id => @place.id)
    }.should change(Inquiry, :count).by(1)
    
    Inquiry.any_instance.stub(:spam?).and_return(false)
    expect {
      xhr :post, :create, inquiry_params.merge(:id => @place.id)
    }.should_not change(Inquiry, :count)
    
  end
  
  it "sends an inquiry and creates a new user" do
    Inquiry.any_instance.stub(:spam?).and_return(false)
    expect {
      xhr :post, :create, inquiry_params.merge(:id => @place.id, :name => 'michelle', :email => 'michelle@mail.com')
    }.should change(Inquiry, :count).by(1)

    user = User.last
    user.full_name.should == 'michelle'
    user.email.should == 'michelle@mail.com'
  end

  def inquiry_params(params = {})
    {
      :inquiry => {
        :date_start => 1.month.from_now.to_s,
        :length_stay => '2',
        :length_stay_type => 'months',
        :message => 'Looks like a great place for partying',
      }.merge(params)
    }
  end
end
