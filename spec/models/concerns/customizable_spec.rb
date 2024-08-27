# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'customizable' do |model_class|
  let(:model_instance) { model_class.create }

  before do
    # Create custom attribute definitions for testing
    CustomAttributeDefinition.create(model_type: model_class.name, key: 'color')
    CustomAttributeDefinition.create(model_type: model_class.name, key: 'size')
  end

  describe '#set_custom_attribute' do
    context 'when the custom attribute is valid' do
      it 'creates a new custom attribute' do
        model_instance.set_custom_attribute('color', 'blue')

        expect(model_instance.custom_attributes.count).to eq(1)
        expect(model_instance.custom_attributes.first.value).to eq('blue')
      end

      it 'updates an existing custom attribute' do
        model_instance.set_custom_attribute('color', 'blue')
        model_instance.set_custom_attribute('color', 'green')

        expect(model_instance.custom_attributes.count).to eq(1)
        expect(model_instance.custom_attributes.first.value).to eq('green')
      end
    end

    context 'when the custom attribute is invalid' do
      it 'raises an error' do
        expect { model_instance.set_custom_attribute('invalid_key', 'value') }
          .to raise_error('Invalid custom attribute: invalid_key')
      end
    end
  end

  describe '#set_custom_attributes' do
    it 'sets multiple custom attributes' do
      attributes = { 'color' => 'blue', 'size' => 'large' }
      model_instance.set_custom_attributes(attributes)

      expect(model_instance.custom_attributes.count).to eq(2)
      expect(model_instance.custom_attributes.find_by(key: 'color').value).to eq('blue')
      expect(model_instance.custom_attributes.find_by(key: 'size').value).to eq('large')
    end

    context 'when one of the attributes is invalid' do
      it 'raises an error and does not create valid attributes' do
        attributes = { 'color' => 'blue', 'invalid_key' => 'value' }

        expect { model_instance.set_custom_attributes(attributes) }
          .to raise_error('Invalid custom attribute: invalid_key')
      end
    end
  end

  describe '#custom_attributes_hash' do
    it 'returns custom attributes as a hash' do
      model_instance.set_custom_attribute('color', 'blue')
      model_instance.set_custom_attribute('size', 'large')

      expect(model_instance.custom_attributes_hash).to eq({ 'color' => 'blue', 'size' => 'large' })
    end
  end

  describe '#get_custom_attribute' do
    it 'returns the value of the custom attribute' do
      model_instance.set_custom_attribute('color', 'blue')

      expect(model_instance.get_custom_attribute('color')).to eq('blue')
    end

    it 'returns nil for a non-existent custom attribute' do
      expect(model_instance.get_custom_attribute('size')).to be_nil
    end
  end
end

RSpec.describe Battery, type: :model do
  it_behaves_like 'customizable', Battery
end

RSpec.describe Customer, type: :model do
  it_behaves_like 'customizable', Customer
end
