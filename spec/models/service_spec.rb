require 'spec_helper'

describe Service do
  
  it "assings multiple languages" do
    @service = build(:service)
    @service.language_ids = [0, 1]
    @service.language_1_cd.should == 0
    @service.language_2_cd.should == 1
  end

  it "deletes product when deleting the service" do
    @service = create(:service)

    expect {
      @service.destroy
    }.to change(Product, :count).by(-1)
  end
  
  it "square sized image should work with paperclip upload" do
    square = File.open("#{Rails.root}/db/rake_seed_images/square.png")
    @service = create(:service)
    @service.photos.new(:photo => square)
    @service.save
    @service.photos.first should_not be_nil
  end
end