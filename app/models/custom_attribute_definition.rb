# frozen_string_literal: true

class CustomAttributeDefinition < ApplicationRecord
  validates :model_type, :key, presence: true
  validates :key, uniqueness: { scope: :model_type }
end
