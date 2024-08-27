# frozen_string_literal: true

# spec/factories/custom_attribute_definitions.rb
FactoryBot.define do
  factory :custom_attribute_definition do
    model_type { 'Customer' }
    key { Faker::Lorem.word }
  end
end
