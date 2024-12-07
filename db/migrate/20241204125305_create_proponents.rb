# frozen_string_literal: true

class CreateProponents < ActiveRecord::Migration[7.1]
  def change
    create_table :proponents do |t|
      t.string :name
      t.string :cpf
      t.date :birth_date
      t.string :personal_phone
      t.string :reference_phone
      t.decimal :salary

      t.timestamps
    end
  end
end
