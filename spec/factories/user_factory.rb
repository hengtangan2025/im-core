FactoryGirl.define do
  factory :user do
    sequence(:login) { |n| "user-#{n}" }
    sequence(:email) { |n| "user-#{n}@rspec.com"}
    password '123456'
  end
end
