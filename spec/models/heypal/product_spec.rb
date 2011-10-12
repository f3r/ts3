require 'spec_helper'

describe Heypal::Product do

  it "should return a list of items" do 
    results = Heypal::Product.find

    puts "will the json work? #{results.inspect}"

    results.should be_instance_of(Hash)
  end

end
