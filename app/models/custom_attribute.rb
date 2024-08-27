class CustomAttribute < ApplicationRecord
  belongs_to :customizable, polymorphic: true

  validates :key, presence: true
  validates :value, presence: true
end
