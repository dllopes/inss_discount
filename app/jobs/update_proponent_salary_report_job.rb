# frozen_string_literal: true

class UpdateProponentSalaryReportJob < ApplicationJob
  queue_as :default

  def perform
    ProponentSalaryReport.delete_all

    SalaryCalculator::SALARY_RANGES.each do |range, label|
      proponents = Proponent.where(salary: range)
      count = proponents.count
      ids = proponents.pluck(:id)

      Rails.logger.info "Range: #{label}, Count: #{count}, Salaries: #{proponents.pluck(:salary)}, IDs: #{ids}"

      ProponentSalaryReport.create!(
        salary_range: label,
        proponent_count: count,
        proponent_ids: ids
      )
    end

    ActionCable.server.broadcast('report_status_channel', { message: 'Relatório pronto!' })
  end
end