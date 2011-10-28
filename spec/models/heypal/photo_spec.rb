require 'spec_helper'

describe Heypal::Photo do

  it "should instantiate" do
    photo = Heypal::Photo.new

    photo.photo = File.open("/tmp/photo.png")

    photo.save_attached_files

  end


end
