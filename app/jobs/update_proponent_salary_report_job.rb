# frozen_string_literal: true

class UpdateProponentSalaryReportJob < ApplicationJob
  queue_as :default

  def perform
    ProponentSalaryReport.delete_all

    SalaryCalculator::SALARY_RANGES.each do |range, label|
      count = Proponent.where(salary: range).count
      Rails.logger.info "Range: #{label}, Count: #{count}, Salaries: #{Proponent.where(salary: range).pluck(:salary)}"
      ProponentSalaryReport.create!(salary_range: label, proponent_count: count)
    end

    ActionCable.server.broadcast('report_status_channel', { message: 'Relatório pronto!' })
  end
end
