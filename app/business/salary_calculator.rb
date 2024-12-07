# frozen_string_literal: true

class SalaryCalculator < ApplicationBusiness
  MAX_SALARY = 6101.06
  BRACKETS = [
    { lower_limit: 0.00, upper_limit: 1045.00, rate: 0.075 },
    { lower_limit: 1045.01, upper_limit: 2089.60, rate: 0.09 },
    { lower_limit: 2089.61, upper_limit: 3134.40, rate: 0.12 },
    { lower_limit: 3134.41, upper_limit: MAX_SALARY, rate: 0.14 }
  ].freeze

  SALARY_RANGES = {
    (0.0..1045.0) => 'Até R$ 1.045,00',
    (1045.01..2089.60) => 'De R$ 1.045,01 a R$ 2.089,60',
    (2089.61..3134.40) => 'De R$ 2.089,61 até R$ 3.134,40',
    (3134.41..MAX_SALARY) => 'De R$ 3.134,41 até R$ 6.101,06'
  }.freeze

  attr_reader :salary

  def initialize(salary)
    super()
    raise ArgumentError, 'Salary must be positive' if salary.nil? || salary <= 0
    @salary = salary
  end

  def call
    {
      inss_discount: calculate_inss_discount,
      salary_range: salary_range
    }
  end

  def call!
    raise ArgumentError, 'Salary must be positive' if salary.nil? || salary <= 0

    call
  end

  def calculate_inss_discount
    return 0 if salary.nil? || salary <= 0

    adjusted_salary = [salary, MAX_SALARY].min

    BRACKETS.inject(0.0) do |discount, bracket|
      if adjusted_salary > bracket[:lower_limit]
        taxable_income = [adjusted_salary, bracket[:upper_limit]].min - bracket[:lower_limit]
        discount + (taxable_income * bracket[:rate]).truncate(2)
      else
        discount
      end
    end.truncate(2)
  end

  def salary_range
    SALARY_RANGES.each do |range, label|
      return label if range.include?(salary)
    end

    'Acima do limite máximo'
  end
end
