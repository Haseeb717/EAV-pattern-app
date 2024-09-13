# frozen_string_literal: true

# app/models/concerns/customizable.rb
module Customizable
  extend ActiveSupport::Concern

  included do
    has_many :custom_attributes, as: :customizable, dependent: :destroy
    after_initialize :load_custom_attributes_cache
    after_find :load_custom_attributes_cache
    after_create :load_custom_attribute_definitions
  end

  # Set a custom attribute with validation against CustomAttributeDefinition
  def set_custom_attribute(key, value)
    load_custom_attribute_definitions
    raise "Invalid custom attribute: #{key}" unless valid_custom_attribute?(key)

    attribute = custom_attributes.find_or_initialize_by(key:)
    attribute.value = value

    raise "Failed to save custom attribute: #{attribute.errors.full_messages.join(', ')}" unless attribute.save

    update_custom_attributes_cache(key, value)
  end

  # Set multiple custom attributes with validation and bulk updates
  def set_custom_attributes(attrs)
    ActiveRecord::Base.transaction do
      attrs.each { |key, value| set_custom_attribute(key, value) }
    end
  end

  # Get a custom attribute by key
  def get_custom_attribute(key)
    @custom_attributes_cache[key] || custom_attributes.find_by(key:)&.value
  end

  # Get all custom attributes as a hash
  def custom_attributes_hash
    @custom_attributes_cache
  end

  # Query method for custom attributes using SQL-friendly logic
  def self.with_custom_attribute(key, value)
    joins(:custom_attributes).where(custom_attributes: { key:, value: })
  end

  # Define a custom attribute key for a specific model
  def self.define_custom_attribute(model_type, key)
    CustomAttributeDefinition.find_or_create_by(model_type:, key:)
  end

  private

  # Load custom attributes into a cache for quick access
  def load_custom_attributes_cache
    @load_custom_attributes_cache ||= custom_attributes.pluck(:key, :value).to_h
  end

  # Update the cache after setting a custom attribute
  def update_custom_attributes_cache(key, value)
    @custom_attributes_cache[key] = value
  end

  def load_custom_attribute_definitions
    @custom_attribute_definitions = CustomAttributeDefinition
                                    .where(model_type: self.class.name)
                                    .pluck(:key)
                                    .to_set
    Rails.logger.debug "Loaded custom attribute definitions: #{@custom_attribute_definitions.inspect}"
  end

  # Validate custom attribute keys against definitions
  def valid_custom_attribute?(key)
    load_custom_attribute_definitions if @custom_attribute_definitions.nil?
    @custom_attribute_definitions.include?(key)
  end
end
