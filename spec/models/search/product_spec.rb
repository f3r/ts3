require 'spec_helper'

describe Search::Product do
  before(:each) do
    #@user = create(:user)
    @search = Search::Product.new

  end

  it "searches amenities" do
    am1 = create(:amenity, :id => 3)
    am1 = create(:amenity, :id => 4)
    am1 = create(:amenity, :id => 1)
    @search.amenity_ids = [3, 4, 1]

    @search.send(:prepare_conditions) # Protected method
    conditions = @search.instance_variable_get("@sql_conditions") # Look inside the object
    
    conditions[0][0].should  == "products.amenities_search like ?"
    conditions[0][1].should  == "%<1>%<3>%<4>%"
  end
  
  context "Price bounds" do
    before(:each) do
      @pt1 = create(:category)
      @search.currency = create(:currency,:currency_code => 'USD')
      @search.stub(:price_unit).and_return(:sale)
    end

    it "returns price step single product" do
      @p1 = create(:product, :category => @pt1, :price_sale => 1000,:published => true)
      @search.category_ids = [@pt1.id]
      @search.price_range_bounds
      @search.price_step.should == 1
    end
    
    it "returns price step 1 for very small range product" do
      @p1 = create(:product, :category => @pt1, :price_sale => 20,:published => true)
      @p2 = create(:product, :category => @pt1, :price_sale => 30,:published => true)
      @search.category_ids = [@pt1.id]
      @search.price_range_bounds
      @search.price_step.should == 1
    end
    
    it "returns 10 step" do
      @p1 = create(:product, :category => @pt1, :price_sale => 1000,:published => true)
      @p2 = create(:product, :category => @pt1, :price_sale => 1200,:published => true)
      @p3 = create(:product, :category => @pt1, :price_sale => 2000,:published => true)
      @search.category_ids = [@pt1.id]
      @search.price_range_bounds
      # (2000 - 1000 ) / 100 = 10
      @search.price_step.should == 10
    end

    it "returns 5 step for range 5..9" do
      @p1 = create(:product, :category => @pt1, :price_sale => 1000,:published => true)
      @p3 = create(:product, :category => @pt1, :price_sale => 1600,:published => true)
      @search.category_ids = [@pt1.id]
      @search.price_range_bounds
      # (1900 - 1000 ) / 100 = 9
      @search.price_step.should == 5
    end

    it "returns factor of 10 for range 11..100" do
      @p1 = create(:product, :category => @pt1, :price_sale => 1000,:published => true)
      @p3 = create(:product, :category => @pt1, :price_sale => 3500,:published => true)
      @search.category_ids = [@pt1.id]
      @search.price_range_bounds
      # (3500 - 1000 ) / 100 = 25 - rounding down to the nearest factor of 10 = 20
      @search.price_step.should satisfy {|n| n % 10 == 0}
    end

    it "returns 100 for range > 100" do
      @p1 = create(:product, :category => @pt1, :price_sale => 1000,:published => true)
      @p3 = create(:product, :category => @pt1, :price_sale => 12000,:published => true)
      @search.category_ids = [@pt1.id]
      @search.price_range_bounds
      # (12000 - 1000 ) / 100 = 110
      @search.price_step.should == 100
    end
    
  end  
end
