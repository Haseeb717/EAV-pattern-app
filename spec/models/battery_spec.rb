# frozen_string_literal: true

# spec/models/battery_spec.rb
require 'rails_helper'

RSpec.describe Battery, type: :model do
  it { should have_many(:custom_attributes).dependent(:destroy) }

  describe 'custom attributes' do
    let!(:make_definition) { create(:custom_attribute_definition, model_type: 'Battery', key: 'make') }
    let!(:battery) { create(:battery) }

    before do
      battery.send(:load_custom_attribute_definitions)
    end

    it 'sets and retrieves custom attributes' do
      battery.set_custom_attribute('make', 'BrandX')
      expect(battery.get_custom_attribute('make')).to eq('BrandX')
    end

    it 'validates custom attributes against definitions' do
      expect { battery.set_custom_attribute('invalid_key', 'value') }
        .to raise_error('Invalid custom attribute: invalid_key')
    end
  end
end
