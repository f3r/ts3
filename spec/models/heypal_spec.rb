require 'spec_helper'

describe Heypal do
  it 'should have the PRODUCTS_URl constant' do
    Heypal::PRODUCTS_URL.should_not be_blank
  end
end

