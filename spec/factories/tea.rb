FactoryBot.define do 

  factory :tea do 
    title { Faker::Tea.variety }
    description { Faker::Books::Lovecraft.word }
    temp { Faker::Number.between(from: 80, to: 90) }
    brewtime { Faker::Number.between(from: 2, to: 10) }
  end 
end 