FactoryBot.define do
  factory :user do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    role { 'buyer' }
  end

  trait :admin do
    role { 'admin' }
  end
end
