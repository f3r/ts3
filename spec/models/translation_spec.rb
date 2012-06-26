require 'spec_helper'

describe Translation do
  context "versioning" do
    before(:each) do
      @translation = Translation.create(:locale => "en", :key => "TEST", :value => "TEST");
    end
    it "stores a version" do
      
      #intially no version
      @translation.versions.count.should == 0
      @translation.value = "TEST_CHANGE"
      @translation.save
      @translation.versions.count.should == 1
    end
    
    it "check the version content" do
      old_val = @translation.value
      @translation.value = "TEST_CHANGE"
      @translation.save
      @translation.versions.first.value.should == old_val
    end
    
    it "deletion should remove the versions" do
      @translation.value = "TEST_CHANGE"
      @translation.save
      
      @translation.versions.count.should == 1
      
      @translation.destroy
      @translation.versions.first.should be_nil
    end
  end
end
