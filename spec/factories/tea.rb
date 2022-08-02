FactoryBot.define do 

  factory :tea do 
    title { Faker::Tea.variety }
    description { Faker::Books::Lovecraft.word }
    temp { Faker::Number.between(from: 100, to: 200) }
    brewtime { Faker::Number.between(from: 5, to: 15) }
  end 
end 