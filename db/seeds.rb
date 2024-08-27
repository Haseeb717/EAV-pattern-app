# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Clear existing data
CustomAttributeDefinition.destroy_all
Customer.destroy_all
Battery.destroy_all

# Create custom attribute definitions
CustomAttributeDefinition.create(model_type: 'Customer', key: 'email')
CustomAttributeDefinition.create(model_type: 'Customer', key: 'hometown')
CustomAttributeDefinition.create(model_type: 'Battery', key: 'make')
CustomAttributeDefinition.create(model_type: 'Battery', key: 'model')

# Create customers with custom attributes
customer1 = Customer.create(name: 'John Doe', phone_number: '1234567890')
customer1.set_custom_attribute('email', 'john.doe@example.com')

customer2 = Customer.create(name: 'Jane Smith', phone_number: '9876543210')
customer2.set_custom_attribute('email', 'jane.smith@example.com')
customer2.set_custom_attribute('hometown', 'Springfield')

# Create batteries with custom attributes
battery1 = Battery.create(capacity: 4000)
battery1.set_custom_attribute('make', 'BrandX')
battery1.set_custom_attribute('model', 'UltraBattery')

battery2 = Battery.create(capacity: 5000)
battery2.set_custom_attribute('make', 'BrandY')
battery2.set_custom_attribute('model', 'MegaBattery')

puts 'Seed data created!'
