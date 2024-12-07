# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateProponentSalaryReportJob, type: :job do
  before do
    create_list(:proponent, 5, salary: 800)
    create_list(:proponent, 3, salary: 1500)
    create_list(:proponent, 2, salary: 2500)
    create_list(:proponent, 4, salary: 5000)

    ProponentSalaryReport.delete_all
  end

  it 'removes existing reports before creating new ones' do
    ProponentSalaryReport.create!(salary_range: 'dummy', proponent_count: 10)

    expect { described_class.perform_now }.to change(ProponentSalaryReport, :count).from(1).to(4)
  end

  it 'creates reports with correct counts for salary ranges' do
    described_class.perform_now

    expected_counts = {
      'Até R$ 1.045,00' => 5,
      'De R$ 1.045,01 a R$ 2.089,60' => 3,
      'De R$ 2.089,61 até R$ 3.134,40' => 2,
      'De R$ 3.134,41 até R$ 6.101,06' => 4
    }

    expected_counts.each do |range_name, count|
      report = ProponentSalaryReport.find_by(salary_range: range_name)
      expect(report).not_to be_nil
      expect(report.proponent_count).to eq(count)
    end
  end

  it 'creates reports with count zero for salary ranges without proponents' do
    Proponent.where(salary: 0..1045).destroy_all

    described_class.perform_now

    report = ProponentSalaryReport.find_by(salary_range: 'Até R$ 1.045,00')
    expect(report).not_to be_nil
    expect(report.proponent_count).to eq(0)
  end
end
