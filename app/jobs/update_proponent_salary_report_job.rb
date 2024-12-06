# frozen_string_literal: true

class UpdateProponentSalaryReportJob < ApplicationJob
  queue_as :default

  def perform
    ProponentSalaryReport.delete_all

    salary_ranges = {
      '0-1045' => 0.0..1045.0,
      '1045.01-2089.60' => 1045.01..2089.60,
      '2089.61-3134.40' => 2089.61..3134.40,
      '3134.41-6101.06' => 3134.41..6101.06
    }

    salary_ranges.each do |range_name, range|
      count = Proponent.where(salary: range).count
      ProponentSalaryReport.create!(salary_range: range_name, proponent_count: count)
    end
  end
end