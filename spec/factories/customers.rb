# frozen_string_literal: true

# spec/factories/customers.rb
FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
