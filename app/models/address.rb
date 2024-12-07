# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :proponent

  validates :street, :number, :neighborhood, :city, :state, :zip_code, presence: true
end
