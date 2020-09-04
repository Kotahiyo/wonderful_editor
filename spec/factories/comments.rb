FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentences }
    user
    article
  end
end
