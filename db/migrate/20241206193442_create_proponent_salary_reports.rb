# frozen_string_literal: true

class CreateProponentSalaryReports < ActiveRecord::Migration[7.0]
  def change
    create_table :proponent_salary_reports do |t|
      t.string :salary_range, null: false
      t.integer :proponent_count, null: false, default: 0
      t.integer :proponent_ids, array: true, default: [], null: false

      t.timestamps
    end
  end
end
