# frozen_string_literal: true

# spec/factories/batteries.rb
FactoryBot.define do
  factory :battery do
    capacity { Faker::Number.between(from: 3000, to: 5000) }
  end
end
