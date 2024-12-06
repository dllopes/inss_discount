require 'rails_helper'

RSpec.describe Proponent, type: :model do
  describe '.calculate_inss_discount' do
    context 'when salary is nil or zero' do
      it 'returns 0 when salary is nil' do
        expect(Proponent.calculate_inss_discount(nil)).to eq(0.0)
      end

      it 'returns 0 when salary is zero' do
        expect(Proponent.calculate_inss_discount(0.0)).to eq(0.0)
      end

      it 'returns 0 when salary is negative' do
        expect(Proponent.calculate_inss_discount(-1000.0)).to eq(0.0)
      end
    end

    context 'when salary is in the first bracket' do
      it 'calculates correctly for salaries up to R$ 1,045.00' do
        expect(Proponent.calculate_inss_discount(1045.00)).to eq(78.37)
      end
    end

    context 'when salary is in the second bracket' do
      it 'calculates correctly for a salary of R$ 1,500.00' do
        expect(Proponent.calculate_inss_discount(1500.00)).to eq(119.31)
      end
    end

    context 'when salary is in the third bracket' do
      it 'calculates correctly for a salary of R$ 3,000.00' do
        expect(Proponent.calculate_inss_discount(3000.00)).to eq(281.62)
      end
    end

    context 'when salary is in the fourth bracket' do
      it 'calculates correctly for a salary of R$ 5,000.00' do
        expect(Proponent.calculate_inss_discount(5000.00)).to eq(558.93)
      end
    end

    context 'when salary exceeds the maximum limit' do
      it 'calculates the discount using the upper limit of the last bracket' do
        expect(Proponent.calculate_inss_discount(7000.00)).to eq(713.08)
      end
    end

    context 'edge cases' do
      it 'calculates correctly at the boundary between the second and third brackets' do
        salary = 2089.60
        expected_discount = 78.37 + 94.01
        expect(Proponent.calculate_inss_discount(salary)).to eq(expected_discount)
      end

      it 'calculates correctly at the boundary between the third and fourth brackets' do
        salary = 3134.40
        expected_discount = 78.37 + 94.01 + 125.37
        expect(Proponent.calculate_inss_discount(salary)).to eq(expected_discount)
      end

      it 'calculates correctly at the maximum salary limit' do
        salary = 6101.06
        expected_discount = 78.37 + 94.01 + 125.37 + 415.33
        expected_discount = (expected_discount * 100).floor / 100.0
        expect(Proponent.calculate_inss_discount(salary)).to eq(expected_discount)
      end
    end
  end
end