FactoryBot.define do
  factory :proponent do
    name { Faker::Name.name }
    cpf { Faker::IdNumber.brazilian_citizen_number }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    personal_phone { Faker::PhoneNumber.cell_phone_in_e164 }
    reference_phone { Faker::PhoneNumber.cell_phone_in_e164 }
    salary { rand(500..6000) }

    after(:create) do |proponent|
      create(:address, proponent: proponent)
    end
  end
end