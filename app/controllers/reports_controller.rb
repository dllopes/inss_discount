# frozen_string_literal: true

class ReportsController < ApplicationController
  def index
    @salary_reports = ProponentSalaryReport.all
  end

  def generate
    UpdateProponentSalaryReportJob.perform_later

    respond_to(&:js)
  end
end
