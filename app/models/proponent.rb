class Proponent < ApplicationRecord
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address

  validates :name, :cpf, :birth_date, :personal_phone, :salary, presence: true
  validates :cpf, uniqueness: true

  before_save :calculate_inss_discount

  def salary_range
    SalaryCalculator.new(salary).salary_range
  end

  private

  def calculate_inss_discount
    self.inss_discount = SalaryCalculator.new(salary).calculate_inss_discount
  end
end