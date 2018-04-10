FactoryBot.define do
  factory :property do
    association :user
    title 'building'
    value 350
  end
end
