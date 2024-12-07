# frozen_string_literal: true

class ReportsController < ApplicationController
  def index
    @salary_ranges = ProponentSalaryReport.pluck(:salary_range, :proponent_count)
  end

  def generate
    UpdateProponentSalaryReportJob.perform_later

    respond_to(&:js)
  end
end
