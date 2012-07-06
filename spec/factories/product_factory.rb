FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.words(2).to_sentence }
  end

  factory :product do
    user
    title        { Faker::Lorem.words(2).to_sentence }
    description  { Faker::Lorem.paragraph }
    address_1    { Faker::Address.street_address }
    address_2    { Faker::Address.secondary_address }
    zip          { Faker::Address.zip }
    currency
    city
    price_per_month { 1000 }
  end

  factory :service do
    product
  end

  factory :amenity do
    name         { Faker::Name.name }
  end
 end