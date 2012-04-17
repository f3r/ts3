require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the PlacesHelper. For example:
#
# describe PlacesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe PlacesHelper do
  context "#place_type_filters" do
    it "returns available types" do
      filters = place_type_filters({"apartment"=>5, "house"=>2, "villa"=>0, "room"=>0, "other_space"=>0})

      filters[0][0].slug.should == "apartment"
      filters[0][1].should == 5

      filters[1][0].slug.should == "house"
      filters[1][1].should == 2
    end
  end
end
