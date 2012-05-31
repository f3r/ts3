require 'spec_helper'

describe PhotosController do
  before(:each) do
    @agent   = create(:user, :role => "agent")
    login_as @agent
    @place   = create(:place, :user => @agent)
  end

  it "uploads a photo" do
    expect {
      post :create, { :place_id => @place.id,
        :photo => fixture_file_upload("#{Rails.root}/spec/files/prop.jpg", 'image/jpg')
      }
      response.should be_success
    }.to change(Photo, :count).by(1)
  end

  it "removes a photo" do
    @photo = create(:photo, :place => @place)

    expect {
      xhr :post, :destroy, { :place_id => @place.id, :id => @photo.id }
      response.should be_success
    }.to change(Photo, :count).by(-1)
  end

  it "unpublishes the property when removing a picture and the total count is < 3" do
    @place   = create(:published_place, :user => @agent)
    assert @place.published
    @place.photos.count.should == 3
    photo = @place.photos.first

    xhr :post, :destroy, {:place_id => @place.id, :id => photo.id}
    response.should be_success

    @place.reload
    assert !@place.published
  end

  it "reorders photos" do
    @place   = create(:published_place, :user => @agent)
    @place.photos.count.should == 3
    photo1, photo2, photo3 = @place.photos.all[0..2]

    ordered_ids = [photo3.id, photo1.id, photo2.id]

    xhr :put, :sort, {:place_id => @place.id, :photo_ids => ordered_ids}
    response.should be_success

    photo_ids =  @place.photos.reload.collect(&:id)
    photo_ids.should == ordered_ids
  end
end