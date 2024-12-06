class Proponent < ApplicationRecord
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address

  validates :name, :cpf, :birth_date, :personal_phone, :salary, presence: true
  validates :cpf, uniqueness: true
end