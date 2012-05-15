FactoryGirl.define do
  factory :city do
    name                  { Faker::Address.city }
    country               { Faker::Address.country }
    active                { true }
  end
end