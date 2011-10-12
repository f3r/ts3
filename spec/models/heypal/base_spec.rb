require 'spec_helper'

describe Heypal::Base do

  it "should have a get method" do
    Heypal::Base.respond_to?(:get).should be_true
  end

  it "should have a post method" do
    Heypal::Base.respond_to?(:post).should be_true
  end 

  it "should have a put method" do
    Heypal::Base.respond_to?(:put).should be_true
  end

  it "should have a delete method" do
    Heypal::Base.respond_to?(:delete).should be_true
  end  

end
