FactoryGirl.define do
  factory :organization_node do
    sequence(:name) { |n| "test-o-#{n}" }
  end
end