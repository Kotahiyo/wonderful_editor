FactoryBot.define do
  factory :article do
    title { Faker::Lorem.characters(number: 20) }
    body { Faker::Lorem.sentence }
    user

    trait :draft do
      status { :draft }
    end

    trait :published do
      status { :published }
    end
  end
end
