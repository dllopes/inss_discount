FactoryBot.define do
  factory :address do
    street { Faker::Address.street_name }
    number { rand(1..1000).to_s }
    neighborhood { Faker::Address.community }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip_code }
    proponent
  end
end