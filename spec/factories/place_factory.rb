include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :place_type do
    name { Faker::Lorem.words(2).to_sentence }
  end

  factory :place do
    title        { Faker::Lorem.words(2).to_sentence }
    description  { Faker::Lorem.paragraph }
    address_1    { Faker::Address.street_address }
    address_2    { Faker::Address.secondary_address }
    zip          { Faker::Address.zip }
    city
    num_bedrooms { 2 }
    max_guests   { 4 }
    place_type
    user
    amenities_tv { true }
    size_unit    { 'meters' }
    size         { 100 }

    factory :published_place do
      published        { true }
      currency         { "JPY"}
      price_per_month  { 400000 }
      photos           { 3.times.collect{ p = Photo.new; p.save(:validate => false); p } }
    end
  end

  factory :photo do
    name   { Faker::Name.name }
    photo  ActionController::TestCase.fixture_file_upload('spec/files/prop.jpg', 'image/jpg')
    #association :place, :factory => :valid_place
  end

end