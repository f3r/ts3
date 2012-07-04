require 'spec_helper'

describe Search::Product do
  before(:each) do
    #@user = create(:user)
    @search = Search::Product.new
  end

  it "searches amenities" do
    @search.amenity_ids = [3, 4, 1]

    @search.send(:prepare_conditions) # Protected method
    conditions = @search.instance_variable_get("@sql_conditions") # Look inside the object
    
    conditions[0][0].should  == "products.amenities_search like ?"
    conditions[0][1].should  == "%<1>%<3>%<4>%"
  end
end
