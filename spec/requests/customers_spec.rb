# frozen_string_literal: true

# spec/requests/customers_spec.rb
require 'rails_helper'

RSpec.describe 'Customers', type: :request do
  let!(:email_definition) { create(:custom_attribute_definition, model_type: 'Customer', key: 'email') }

  describe 'POST /customers' do
    let(:valid_params) do
      { customer: { name: 'John Doe', phone_number: '1234567890', email: 'john.doe@example.com' } }
    end

    it 'creates a customer with custom attributes' do
      post '/customers', params: valid_params
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['email']).to eq('john.doe@example.com')
    end
  end

  describe 'PUT /customers/:id' do
    let!(:customer) { create(:customer) }

    it 'updates customer with custom attributes' do
      put "/customers/#{customer.id}", params: { customer: { email: 'new.email@example.com' } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['email']).to eq('new.email@example.com')
    end
  end
end
