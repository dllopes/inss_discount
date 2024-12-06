class Proponent < ApplicationRecord
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address

  validates :name, :cpf, :birth_date, :personal_phone, :salary, presence: true
  validates :cpf, uniqueness: true

  def self.calculate_inss_discount(salary)
    return 0 if salary.nil? || salary <= 0

    max_salary = 6101.06
    salary = [salary, max_salary].min

    brackets = [
      { lower_limit: 0.00, upper_limit: 1045.00, rate: 0.075 },
      { lower_limit: 1045.01, upper_limit: 2089.60, rate: 0.09 },
      { lower_limit: 2089.61, upper_limit: 3134.40, rate: 0.12 },
      { lower_limit: 3134.41, upper_limit: max_salary, rate: 0.14 }
    ]

    discount = 0.0

    brackets.each do |bracket|
      if salary > bracket[:lower_limit]
        taxable_income = [salary, bracket[:upper_limit]].min - bracket[:lower_limit]
        bracket_tax = (taxable_income * bracket[:rate]).truncate(2)
        discount += bracket_tax
      end
    end

    discount.truncate(2)
  end

  def salary_range
    case salary
    when 0..1045 then 'Até R$ 1.045,00'
    when 1045.01..2089.60 then 'De R$ 1.045,01 a R$ 2.089,60'
    when 2089.61..3134.40 then 'De R$ 2.089,61 até R$ 3.134,40'
    else 'De R$ 3.134,41 até R$ 6.101,06'
    end
  end
end