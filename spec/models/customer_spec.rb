# frozen_string_literal: true

# spec/models/customer_spec.rb
require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should have_many(:custom_attributes).dependent(:destroy) }

  describe 'custom attributes' do
    let!(:customer) { create(:customer) }
    let!(:email_definition) { create(:custom_attribute_definition, model_type: 'Customer', key: 'email') }

    before do
      customer.send(:load_custom_attribute_definitions)
    end

    it 'sets and retrieves custom attributes' do
      customer.set_custom_attribute('email', 'john.doe@example.com')
      expect(customer.get_custom_attribute('email')).to eq('john.doe@example.com')
    end

    it 'validates custom attributes against definitions' do
      expect { customer.set_custom_attribute('nonexistent', 'value') }
        .to raise_error('Invalid custom attribute: nonexistent')
    end
  end
end
