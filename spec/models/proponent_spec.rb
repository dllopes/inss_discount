require 'rails_helper'

RSpec.describe Proponent, type: :model do
  describe '#salary_range' do
    let(:salary) { 3000.00 }
    let(:proponent) { build(:proponent, salary: salary) }

    it 'returns the correct salary range for the salary' do
      calculator = instance_double(SalaryCalculator, salary_range: 'De R$ 2.089,61 até R$ 3.134,40')
      allow(SalaryCalculator).to receive(:new).with(salary).and_return(calculator)

      expect(proponent.salary_range).to eq('De R$ 2.089,61 até R$ 3.134,40')
      expect(SalaryCalculator).to have_received(:new).with(salary)
    end
  end

  describe 'callbacks' do
    it 'calculates inss_discount before saving' do
      proponent = build(:proponent, salary: 3000.00, inss_discount: nil)
      proponent.save
      expect(proponent.inss_discount).to eq('281.62')
    end
  end
end