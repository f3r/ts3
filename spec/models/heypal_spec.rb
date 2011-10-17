require 'spec_helper'

describe Heypal do
  it 'should have the base url' do
    Heypal::base_url.should_not be_blank
  end
end

