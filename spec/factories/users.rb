FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: Random.new.rand(2..50)) }
    sequence(:email) {|n| "#{n}_#{Faker::Internet.email}" }
    # Fakerで生成したパスワードでは半角大文字、小文字、数字それぞれ一文字ずつの条件を満たせないことがあるため先頭に”Aa1”をつけた
    password { "Aa1" + Faker::Internet.password(min_length: 5, max_length: 29, mix_case: true, special_characters: true) }
  end
end
