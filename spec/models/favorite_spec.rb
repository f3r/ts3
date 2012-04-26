require 'spec_helper'

describe Favorite do
  it "stores a user favorite" do
    user_id = 23
    place_id = 45
    fav = Favorite.create(
      :user_id => user_id,
      :favorable_id => place_id,
      :favorable_type => 'Place'
    )
    fav.should be_persisted
  end
end
