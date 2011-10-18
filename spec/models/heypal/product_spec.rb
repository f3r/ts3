require 'spec_helper'

describe Heypal::Product do

  it "should return a list of products" do 
    results = Heypal::Product.all
    results.should be_instance_of(Array)
  end

  it "should have a valid resource path" do
    Heypal::Product.resource_url.should == 'http://localhost:3006/samples/products.json'
  end
  
  context 'Product' do

    before do
      @product = Heypal::Product.find('test')
    end

    it "should return a product" do 
      @product.should be_instance_of(Heypal::Product)
    end

    it "should return valid location" do
      @product['location']['city'] = 'somecity'
      @product['location']['country'] = 'inthecountry'

      @product.location.should == "somecity, inthecountry"
    end

  end

end
