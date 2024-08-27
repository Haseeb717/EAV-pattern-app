# frozen_string_literal: true

# spec/requests/batteries_spec.rb
require 'rails_helper'

RSpec.describe 'Batteries', type: :request do
  let!(:make_definition) { create(:custom_attribute_definition, model_type: 'Battery', key: 'make') }

  describe 'POST /batteries' do
    let(:valid_params) do
      { battery: { capacity: 4000, make: 'BrandX' } }
    end

    it 'creates a battery with custom attributes' do
      post '/batteries', params: valid_params
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['make']).to eq('BrandX')
    end
  end

  describe 'PUT /batteries/:id' do
    let!(:battery) { create(:battery) }

    it 'updates battery with custom attributes' do
      put "/batteries/#{battery.id}", params: { battery: { make: 'BrandY' } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['make']).to eq('BrandY')
    end
  end
end
