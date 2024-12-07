# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

FactoryBot.create(:user, email: 'admin@example.com') if User.count.zero?

if Proponent.count.zero?
  10.times do
    FactoryBot.create(:proponent)
  end
end
