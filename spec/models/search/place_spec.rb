require 'spec_helper'

describe Search::Property do
  before(:each) do
    @user = create(:user)
    @search = Search::Property.new
  end

  context "Fields" do
    it "supports city_id" do
      @search.city_id = 1
      @search.city_id.should == 1
    end
  end

  context "Results" do
    before(:each) do
      @pt1 = create(:category)
      @pt2 = create(:category)

      @p1 = create(:published_place, :category => @pt1, :price_per_month => 1000)
      @p2 = create(:published_place, :category => @pt2, :price_per_month => 4990)
      @p3 = create(:published_place, :category => @pt1, :price_per_month => 3000)
    end

    it "calculates place type filters" do
      filters = @search.category_filters
      filters.size.should == 2

      filters[0][0].should == @pt1
      filters[0][1].should == 2
      filters[1][0].should == @pt2
      filters[1][1].should == 1
    end

    it "calculates price filters" do
      min, max = @search.price_range_bounds
      min.should == 1000
      max.should == 5000

      @search.category_ids = [@pt1.id]
      min, max = @search.price_range_bounds
      min.should == 1000
      max.should == 3000
    end
  end
end