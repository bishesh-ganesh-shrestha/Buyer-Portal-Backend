require 'rails_helper'

RSpec.describe 'Properties API', type: :request do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, 'dev_secret_key', 'HS256') }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let!(:properties) { create_list(:property, 3) }

  describe 'GET /api/v1/properties' do
    context 'when authenticated' do
      it 'returns all properties' do
        get '/api/v1/properties', headers: headers
        body = JSON.parse(response.body)
        expect(body.length).to eq(3)
      end

      it 'returns 200 status' do
        get '/api/v1/properties', headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'includes favourited field for each property' do
        get '/api/v1/properties', headers: headers
        body = JSON.parse(response.body)
        expect(body.first).to have_key('favourited')
      end

      it 'returns favourited as false by default' do
        get '/api/v1/properties', headers: headers
        body = JSON.parse(response.body)
        expect(body.first['favourited']).to be false
      end

      it 'returns favourited as true for favourited properties' do
        create(:favourite, user: user, property: properties.first)
        get '/api/v1/properties', headers: headers
        body = JSON.parse(response.body)
        favourited_property = body.find { |p| p['id'] == properties.first.id }
        expect(favourited_property['favourited']).to be true
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        get '/api/v1/properties'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/properties/:id' do
    context 'when authenticated' do
      it 'returns the property' do
        get "/api/v1/properties/#{properties.first.id}", headers: headers
        body = JSON.parse(response.body)
        expect(body['id']).to eq(properties.first.id)
      end

      it 'returns 200 status' do
        get "/api/v1/properties/#{properties.first.id}", headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'includes favourited field' do
        get "/api/v1/properties/#{properties.first.id}", headers: headers
        body = JSON.parse(response.body)
        expect(body).to have_key('favourited')
      end

      it 'returns 404 for non existent property' do
        get '/api/v1/properties/99999', headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        get "/api/v1/properties/#{properties.first.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
