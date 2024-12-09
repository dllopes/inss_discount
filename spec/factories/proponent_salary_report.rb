# spec/factories/proponent_salary_reports.rb
FactoryBot.define do
  factory :proponent_salary_report do
    salary_range { 'De R$ 1.045,01 a R$ 2.089,60' }
    proponent_count { Faker::Number.between(from: 1, to: 100) }
    proponent_ids { Array.new(proponent_count) { Faker::Number.unique.number(digits: 10) } }
  end
end