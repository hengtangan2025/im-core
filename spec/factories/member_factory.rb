FactoryGirl.define do
  factory :member do
    sequence(:name) { |n| "member-#{n}" }
  end
end
