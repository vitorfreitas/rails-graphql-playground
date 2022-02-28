require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let!(:users) { create_list(:user, 10) }

  describe 'GET /users' do
    before do
      headers = {
        'Authorization' => JsonWebToken.encode({ user_id: 1 })
      }
      get '/users', params: {}, headers: headers
    end

    it 'returns users' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /users' do
    let(:valid_attributes) do
      {
        name: Faker::Name.name,
        username: 'testusername',
        email: 'testemail@mail.com',
        password: Faker::Internet.password
      }
    end

    context 'with valid attributes' do
      before { post '/users', params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid attributes' do
      before { post '/users', params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to include("can't be blank")
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:valid_attributes) { { name: Faker::Name.name } }
    let(:username) { users.first.username }

    before do
      headers = {
        'Authorization' => JsonWebToken.encode({ user_id: 1 })
      }
      put "/users/#{username}", params: valid_attributes, headers: headers
    end

    context 'when user exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the user does not exists' do
      let(:username) { 'notfound' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a failure message' do
        expect(response.body).to include('User not found')
      end
    end
  end
end
