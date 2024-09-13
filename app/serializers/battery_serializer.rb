# app/serializers/battery_serializer.rb
class BatterySerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :capacity

  attribute :custom_attributes do |customer|
    customer.custom_attributes_hash
  end
end
