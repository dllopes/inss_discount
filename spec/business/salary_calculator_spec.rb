require 'rails_helper'

RSpec.describe SalaryCalculator do
  describe '#call' do
    it 'returns correct discount and range for a valid salary' do
      salary = 3000
      calculator = described_class.new(salary)
      result = calculator.call

      expect(result[:inss_discount]).to eq(calculator.calculate_inss_discount)
      expect(result[:salary_range]).to eq(calculator.salary_range)
    end
  end

  describe '#calculate_inss_discount' do
    it 'raises an ArgumentError for salary less than or equal to 0' do
      expect { described_class.new(0).calculate_inss_discount }.to raise_error(ArgumentError, 'Salary must be positive')
    end

    it 'returns 0 for salary less than or equal to MAX_SALARY but in the first bracket' do
      calculator = described_class.new(800.0)
      expect(calculator.calculate_inss_discount).to eq(800.0 * 0.075)
    end
  end

  describe '#salary_range' do
    it 'returns the correct range label for a salary in the first bracket' do
      expect(described_class.new(800).salary_range).to eq('Até R$ 1.045,00')
    end

    it 'returns the correct range label for a salary in the second bracket' do
      expect(described_class.new(1500).salary_range).to eq('De R$ 1.045,01 a R$ 2.089,60')
    end

    it 'returns the correct range label for a salary in the last bracket' do
      expect(described_class.new(5000).salary_range).to eq('De R$ 3.134,41 até R$ 6.101,06')
    end

    it 'returns "Acima do limite máximo" for salary exceeding the maximum limit' do
      expect(described_class.new(7000).salary_range).to eq('Acima do limite máximo')
    end
  end
end