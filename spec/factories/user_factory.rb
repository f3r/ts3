FactoryGirl.define do
  factory :user do
    email                 { Faker::Internet.email }
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    birthdate             { Date.current - 20.year }
    password              { Faker::Lorem.words(2).to_sentence }
    password_confirmation { |u| u.password }
    confirmed_at          { 1.day.ago }
  end
end