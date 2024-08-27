# app/models/concerns/customizable.rb
module Customizable
  extend ActiveSupport::Concern

  included do
    has_many :custom_attributes, as: :customizable, dependent: :destroy
    after_initialize :load_custom_attributes
    after_initialize :load_custom_attribute_definitions
  end

  # Set a custom attribute with validation against CustomAttributeDefinition
  def set_custom_attribute(key, value)
    if valid_custom_attribute?(key)
      attribute = custom_attributes.find_or_initialize_by(key: key)
      attribute.value = value
      attribute.save!
    else
      raise "Invalid custom attribute: #{key}"
    end
  end

  # Set multiple custom attributes with validation
  def set_custom_attributes(attrs)
    attrs.each do |key, value|
      set_custom_attribute(key, value)
    end
  end

  # Get a custom attribute
  def get_custom_attribute(key)
    @custom_attributes_cache[key]
  end

  # Get all custom attributes as a hash
  def custom_attributes_hash
    @custom_attributes_cache
  end

  # Load custom attributes into a cache for quick access
  def load_custom_attributes
    if association(:custom_attributes).loaded?
      @custom_attributes_cache = custom_attributes.to_h { |attr| [attr.key, attr.value] }
    else
      @custom_attributes_cache = custom_attributes.pluck(:key, :value).to_h
    end
  end

  # SQL-friendly query method for custom attributes
  def self.with_custom_attribute(key, value)
    joins(:custom_attributes).where(custom_attributes: { key: key, value: value })
  end

  # Optional: Define a custom attribute key for a specific model
  def self.define_custom_attribute(model_type, key)
    CustomAttributeDefinition.find_or_create_by(model_type: model_type, key: key)
  end

  private

  def load_custom_attribute_definitions
    @custom_attribute_definitions = CustomAttributeDefinition
      .where(model_type: self.class.name)
      .pluck(:key)
      .to_set
  end

  def valid_custom_attribute?(key)
    @custom_attribute_definitions.include?(key)
  end
end


