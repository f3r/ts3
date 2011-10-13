require 'spec_helper'

describe Heypal::Product do

  it "should return a list of products" do 
    results = Heypal::Product.all
    results.should be_instance_of(Hash)
  end

  it "should return a product" do 
    result = Heypal::Product.find('test')
    result.should be_instance_of(Hash)
  end

end
