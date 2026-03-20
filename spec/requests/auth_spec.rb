require 'rails_helper'

RSpec.describe 'Auth API', type: :request do
  describe 'POST /api/v1/register' do
    let(:valid_params) do
      {
        user: {
          name: 'Bishesh Shrestha',
          email: 'bishesh@gmail.com',
          password: 'password123'
        }
      }
    end

    context 'with valid params' do
      it 'creates a new user' do
        expect {
          post '/api/v1/register', params: valid_params, as: :json
        }.to change(User, :count).by(1)
      end

      it 'returns a token' do
        post '/api/v1/register', params: valid_params, as: :json
        expect(JSON.parse(response.body)).to have_key('token')
      end

      it 'returns user data' do
        post '/api/v1/register', params: valid_params, as: :json
        body = JSON.parse(response.body)
        expect(body['user']['email']).to eq('bishesh@gmail.com')
        expect(body['user']['role']).to eq('buyer')
      end

      it 'returns 201 status' do
        post '/api/v1/register', params: valid_params, as: :json
        expect(response).to have_http_status(:created)
      end

      it 'does not expose password_digest' do
        post '/api/v1/register', params: valid_params, as: :json
        body = JSON.parse(response.body)
        expect(body['user']).not_to have_key('password_digest')
      end
    end

    context 'with invalid params' do
      it 'returns 422 when email is already taken' do
        create(:user, email: 'bishesh@gmail.com')
        post '/api/v1/register', params: valid_params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message when email is already taken' do
        create(:user, email: 'bishesh@gmail.com')
        post '/api/v1/register', params: valid_params, as: :json
        body = JSON.parse(response.body)
        expect(body['errors']).to include('Email has already been taken')
      end

      it 'returns 422 when name is missing' do
        post '/api/v1/register', params: { user: { email: 'test@gmail.com', password: 'password123' } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns 422 when password is too short' do
        post '/api/v1/register', params: { user: { name: 'Bishesh Shrestha', email: 'test@gmail.com', password: '123' } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /api/v1/login' do
    let!(:user) { create(:user, email: 'bishesh@gmail.com', password: 'password123') }

    context 'with valid credentials' do
      it 'returns a token' do
        post '/api/v1/login', params: { email: 'bishesh@gmail.com', password: 'password123' }, as: :json
        expect(JSON.parse(response.body)).to have_key('token')
      end

      it 'returns user data' do
        post '/api/v1/login', params: { email: 'bishesh@gmail.com', password: 'password123' }, as: :json
        body = JSON.parse(response.body)
        expect(body['user']['email']).to eq('bishesh@gmail.com')
      end

      it 'returns 200 status' do
        post '/api/v1/login', params: { email: 'bishesh@gmail.com', password: 'password123' }, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid credentials' do
      it 'returns 401 with wrong password' do
        post '/api/v1/login', params: { email: 'bishesh@gmail.com', password: 'wrongpassword' }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 with wrong email' do
        post '/api/v1/login', params: { email: 'wrong@gmail.com', password: 'password123' }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        post '/api/v1/login', params: { email: 'bishesh@gmail.com', password: 'wrongpassword' }, as: :json
        body = JSON.parse(response.body)
        expect(body['error']).to eq('Invalid email or password')
      end
    end
  end
end
