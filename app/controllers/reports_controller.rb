class ReportsController < ApplicationController
  def index
    @salary_ranges = Proponent.all.group_by(&:salary_range).transform_values(&:count)
  end
end