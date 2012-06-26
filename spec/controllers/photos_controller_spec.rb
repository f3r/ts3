require 'spec_helper'

describe PhotosController do
  before(:each) do
    @agent   = create(:agent)
    login_as @agent
    @place   = create(:place, :user => @agent)
    @product = @place.product
  end

  it "uploads a photo" do
    expect {
      post :create, { :product_id => @product.id,
        :file => fixture_file_upload("#{Rails.root}/spec/files/prop.jpg", 'image/jpg')
      }
      response.should be_success
    }.to change(Photo, :count).by(1)
  end

  it "removes a photo" do
    @photo = create(:photo, :product => @product)

    expect {
      xhr :post, :destroy, { :product_id => @product.id, :id => @photo.id }
      response.should be_success
    }.to change(Photo, :count).by(-1)
  end

  it "updates photo label" do
    @photo = create(:photo, :product => @product)
    xhr :put, :update, :id => @photo.id, :product_id => @product.id, :name => 'Nice view'
    response.should be_success

    @photo.reload
    @photo.name.should == 'Nice view'
  end

  it "unpublishes the property when removing a picture and the total count is < 3" do
    @place   = create(:published_place, :user => @agent)
    @product = @place.product
    assert @place.published
    @place.photos.count.should == 3
    photo = @place.photos.first

    xhr :post, :destroy, {:product_id => @product.id, :id => photo.id}
    response.should be_success

    @place.reload
    assert !@place.published
  end

  it "reorders photos" do
    @place   = create(:published_place, :user => @agent)
    @product = @place.product
    @place.photos.count.should == 3
    photo1, photo2, photo3 = @place.photos.all[0..2]

    ordered_ids = [photo3.id, photo1.id, photo2.id]

    xhr :put, :sort, {:product_id => @product.id, :photo_ids => ordered_ids}
    response.should be_success

    photo_ids =  @place.photos.reload.collect(&:id)
    photo_ids.should == ordered_ids
  end
end