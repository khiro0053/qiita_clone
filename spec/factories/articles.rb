FactoryBot.define do
  factory :article do
    title { Faker::Lorem.characters(number: Random.new.rand(1..50)) }
    body { Faker::Lorem.paragraph(sentence_count: 50) }
    status { "draft" }
    user

    trait :draft do
      status { "draft" }
    end

    trait :published do
      status { "published" }
    end
  end
end
