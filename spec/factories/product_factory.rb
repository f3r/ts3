FactoryGirl.define do
  factory :product do
    user
    title        { Faker::Lorem.words(2).to_sentence }
    description  { Faker::Lorem.paragraph }
    address_1    { Faker::Address.street_address }
    address_2    { Faker::Address.secondary_address }
    zip          { Faker::Address.zip }
    city
  end

  factory :service do
    product
  end

  factory :amenity do
    name         { Faker::Name.name }
  end
 end