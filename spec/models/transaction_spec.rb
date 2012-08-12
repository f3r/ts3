require 'spec_helper'

describe Transaction do
  before(:each) do
    @usd = create(:currency, :currency_code => 'USD')
    Currency.stub(:default).and_return(@usd)
  	@inquiry = create(:inquiry)
    Inquiry.any_instance.stub(:price).and_return(1000.to_money('USD'))
  end

  it "charges a flat booking fee" do
  	SiteConfig.stub(:charge_total).and_return(false)
  	SiteConfig.stub(:fee_amount).and_return(300)
  	SiteConfig.stub(:fee_is_fixed).and_return(true)
  	transaction = @inquiry.transaction
  	transaction.total_amount.should == 300
  end

  it "charges a % fee" do
  	SiteConfig.stub(:charge_total).and_return(false)
  	SiteConfig.stub(:fee_amount).and_return(10)
  	SiteConfig.stub(:fee_is_fixed).and_return(false)

  	transaction = @inquiry.transaction
  	transaction.total_amount.should == 100
  end

  it "charges the total + a flat fee" do
    SiteConfig.stub(:charge_total).and_return(true)
    SiteConfig.stub(:fee_amount).and_return(300)
    SiteConfig.stub(:fee_is_fixed).and_return(true)

    transaction = @inquiry.transaction
    transaction.total_amount.should == 1300
  end

  it "charges the total + a % fee" do
    SiteConfig.stub(:charge_total).and_return(true)
    SiteConfig.stub(:fee_amount).and_return(20)
    SiteConfig.stub(:fee_is_fixed).and_return(false)

    transaction = @inquiry.transaction
    transaction.total_amount.should == 1200
  end
end