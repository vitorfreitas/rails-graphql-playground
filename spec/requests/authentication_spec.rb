require 'rails_helper'

RSpec.describe AuthenticationController, type: :request do
  let!(:user) { create(:user, password: '123456') }

  describe 'POST /auth/login' do
    let(:params) { { username: user.username, password: '123456' } }

    before do
      post '/auth/login', params: params
    end

    context 'with valid credentials' do
      it 'should return a jwt token' do
        expect(json['token']).to eql(JsonWebToken.encode(user_id: user.id))
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid credentials' do
      let(:params) { { username: 'notfound', password: '123456' } }

      it 'should return status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'should return a failure message' do
        expect(response.body).to include('Unauthorized')
      end
    end
  end
end
