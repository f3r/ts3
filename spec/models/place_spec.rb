require 'spec_helper'

describe Place do
  before(:each) do
    @usd = create(:currency, :currency_code => 'USD')
    @sgd = create(:currency, :currency_code => 'SGD')
    @hkd = create(:currency, :currency_code => 'HKD')
    @place = build(:place, :currency => 'SGD', :price_per_month => '2000', :price_per_month_usd => '150000')
  end

  context "#price" do
    it "returns the price in the original currency" do
      symbol, amount = @place.price(@sgd)
      symbol.should == @sgd.symbol
      amount.should == @place.price_per_month
    end

    it "returns the price in usd (using the precalculated value)" do
      symbol, amount = @place.price(@usd)
      symbol.should == @usd.symbol
      amount.should == @place.price_per_month_usd
    end

    it "converts to a 3rd currency" do
      @hkd.should_receive(:from_usd).with(1500).and_return(8000)

      symbol, amount = @place.price(@hkd)
      symbol.should == @hkd.symbol
      amount.should == 8000
    end
  end
end