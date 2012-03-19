require 'spec_helper'

describe Heypal::City do
  it "finds cities by name" do
    city = Heypal::City.find_by_name('singapore')
    city.should_not be_nil
    city.code.should == :singapore
  end
end
