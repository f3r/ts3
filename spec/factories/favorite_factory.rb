FactoryGirl.define do
  factory :favorite do
    user_id        1
    favorable_id   Random.rand(10)
    favorable_type 'Place'
  end
end