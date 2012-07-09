require 'spec_helper'

describe Product do
  context "Amenities" do
    before(:each) do
      @product = create(:product)
      @amenities = 3.times.collect{ create(:amenity) }
    end

    it "sets nested amenities" do
      @product.amenity_ids = [@amenities[0].id, @amenities[2].id]
      @product.reload
      @product.amenities.should == [@amenities[0], @amenities[2]]
    end

    it "updates nested amenities" do
      @product.amenities = [@amenities[0], @amenities[1]]
      @product.reload
      @product.amenity_ids = [@amenities[1].id, @amenities[2].id]
      @product.reload
      @product.amenities.should == [@amenities[1], @amenities[2]]
    end

    it "populates a searchable amenities field" do
      @product.amenities = [@amenities[1], @amenities[0]]
      @product.save
      s = @product.amenities_search
      s.should_not be_nil
      s.should == "<#{@amenities[0].id}>,<#{@amenities[1].id}>"
    end
  end

  context "#price" do
    before(:each) do
      @usd = create(:currency, :currency_code => 'USD')
      @sgd = create(:currency, :currency_code => 'SGD')
      @hkd = create(:currency, :currency_code => 'HKD')
      Product.stub(:price_unit).and_return(:per_month)
      @product = build(:product, :currency => @sgd, :price_per_month => '2000', :price_per_month_usd => '150000')
    end

    it "returns the price in the original currency" do
      symbol, amount = @product.price(@sgd)
      symbol.should == @sgd.symbol
      amount.should == @product.price_per_month
    end

    it "returns the price in usd (using the precalculated value)" do
      symbol, amount = @product.price(@usd)
      symbol.should == @usd.symbol
      amount.should == @product.price_per_month_usd / 100
    end

    it "converts to a 3rd currency" do
      @hkd.should_receive(:from_usd).with(1500).and_return(8000)

      symbol, amount = @product.price(@hkd)
      symbol.should == @hkd.symbol
      amount.should == 8000
    end

    it "returns the price as a money object" do
      price = @product.money_price
      price.cents.should == @product.price_per_month * 100
      price.currency_as_string.should == @sgd.currency_code
    end
  end
end
