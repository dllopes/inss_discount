# frozen_string_literal: true

class ProponentSalaryReport < ApplicationRecord
  validates :salary_range, presence: true
  validates :proponent_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
