require 'rails_helper'

RSpec.describe 'Favourites API', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, 'dev_secret_key', 'HS256') }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let!(:property) { create(:property) }

  describe 'GET /api/v1/favourites' do
    context 'when authenticated' do
      it 'returns only current user favourites' do
        create(:favourite, user: user, property: property)
        create(:favourite, user: other_user, property: create(:property))
        get '/api/v1/favourites', headers: headers
        body = JSON.parse(response.body)
        expect(body.length).to eq(1)
      end

      it 'returns 200 status' do
        get '/api/v1/favourites', headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'returns empty array when no favourites' do
        get '/api/v1/favourites', headers: headers
        body = JSON.parse(response.body)
        expect(body).to eq([])
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        get '/api/v1/favourites'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/favourites' do
    context 'when authenticated' do
      it 'creates a favourite' do
        expect {
          post '/api/v1/favourites', params: { property_id: property.id }, headers: headers, as: :json
        }.to change(Favourite, :count).by(1)
      end

      it 'returns 201 status' do
        post '/api/v1/favourites', params: { property_id: property.id }, headers: headers, as: :json
        expect(response).to have_http_status(:created)
      end

      it 'does not allow duplicate favourites' do
        create(:favourite, user: user, property: property)
        post '/api/v1/favourites', params: { property_id: property.id }, headers: headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 404 for non existent property' do
        post '/api/v1/favourites', params: { property_id: 99999 }, headers: headers, as: :json
        expect(response).to have_http_status(:not_found)
      end

      it 'scopes favourite to current user' do
        post '/api/v1/favourites', params: { property_id: property.id }, headers: headers, as: :json
        expect(Favourite.last.user_id).to eq(user.id)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        post '/api/v1/favourites', params: { property_id: property.id }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/favourites/:id' do
    let!(:favourite) { create(:favourite, user: user, property: property) }

    context 'when authenticated' do
      it 'removes the favourite' do
        expect {
          delete "/api/v1/favourites/#{property.id}", headers: headers
        }.to change(Favourite, :count).by(-1)
      end

      it 'returns 200 status' do
        delete "/api/v1/favourites/#{property.id}", headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'does not allow user to delete another users favourite' do
        other_property = create(:property)
        create(:favourite, user: other_user, property: other_property)
        delete "/api/v1/favourites/#{other_property.id}", headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        delete "/api/v1/favourites/#{property.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
