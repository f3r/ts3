require 'spec_helper'

describe Heypal do
  it 'should have the base url' do
    Heypal::base_url = 'http://localhost:3000'
    Heypal::base_url.should == 'http://localhost:3000'
  end
end

