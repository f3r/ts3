FactoryGirl.define do
  factory :city do
    name                  { Faker::Address.city }
    country               { Faker::Address.country }
    active                { true }
  end
end

FactoryGirl.define do
  factory :currency do
    name                  { Faker::Name.name }
    symbol                { '$' }
    country               { Faker::Name.name }
    active                { 1 }
    currency_code         { Faker::Name.prefix }
    currency_abbreviation { Faker::Name.prefix }
  end
end

FactoryGirl.define do
  factory :favorite do
    user_id        1
    favorable_id   Random.rand(10)
    favorable_type 'Place'
  end
end

FactoryGirl.define do
  factory :cmspage do
    page_title  { @title = Faker::Name.name }
    page_url    { @title.parameterize.underscore }
    description { Faker::Lorem.paragraph }
    active      { true }
  end
end

FactoryGirl.define do
  factory :place_type do
    name { Faker::Name.name }
  end
end