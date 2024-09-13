# app/serializers/customer_serializer.rb
class CustomerSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :phone_number

  attribute :custom_attributes do |customer|
    customer.custom_attributes_hash
  end
end
