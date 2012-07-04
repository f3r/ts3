require 'spec_helper'

describe Product do
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
