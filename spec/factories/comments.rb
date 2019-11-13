FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph(sentence_count: 10) }
    user
    article
  end
end
