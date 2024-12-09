# frozen_string_literal: true

class UpdateProponentSalaryReportJob < ApplicationJob
  queue_as :default

  def perform
    ProponentSalaryReport.delete_all
    SalaryCalculator::SALARY_RANGES.each do |range, label|
      process_salary_range(range, label)
    end
    notify_report_ready
  end

  private

  def process_salary_range(range, label)
    proponents = fetch_proponents_in_range(range)
    log_proponent_details(label, proponents)
    create_salary_report(label, proponents)
  end

  def fetch_proponents_in_range(range)
    Proponent.where(salary: range)
  end

  def log_proponent_details(label, proponents)
    Rails.logger.info(
      "Range: #{label}, Count: #{proponents.count}, " \
        "Salaries: #{proponents.pluck(:salary)}, IDs: #{proponents.pluck(:id)}"
    )
  end

  def create_salary_report(label, proponents)
    ProponentSalaryReport.create!(
      salary_range: label,
      proponent_count: proponents.count,
      proponent_ids: proponents.pluck(:id)
    )
  end

  def notify_report_ready
    ActionCable.server.broadcast('report_status_channel', { message: 'Relatório pronto!' })
  end
end