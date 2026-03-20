FactoryBot.define do
  factory :property do
    title { Faker::Address.community }
    address { Faker::Address.full_address }
    price { Faker::Number.between(from: 5000000, to: 50000000) }
    bedrooms { Faker::Number.between(from: 1, to: 5) }
    bathrooms { Faker::Number.between(from: 1, to: 4) }
    area_sqft { Faker::Number.between(from: 500, to: 5000) }
    property_type { %w[Apartment Villa Flat House Commercial].sample }
    description { Faker::Lorem.paragraph }
  end
end
