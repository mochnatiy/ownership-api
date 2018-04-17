RSpec.describe Api::V1::UsersController do
  describe 'POST create', type: :request do
    context 'when registering a new user' do
      let(:login) { 'steve' }

      before do
        post(
          '/api/register',
          params: {
            login: login,
            password: 'password'
          }
        )

        @users = User.where(login: login)
      end

      specify 'should return status 200' do
        expect(response.status).to eq(200)
      end

      specify 'should create one new user' do
        expect(@users.size).to eq(1)
      end

      specify 'should return json with user_id' do
        expect(JSON.parse(response.body).symbolize_keys).to eq(
          { user_id: @users[0].id }
        )
      end
    end

    context 'when trying to register an existing user' do
      let!(:user) { create(:user, login: 'jack') }

      before do
        post(
          '/api/register',
          params: {
            login: 'jack',
            password: 'password'
          }
        )

        @users = User.where(login: 'jack')
      end

      specify 'should return status 422' do
        expect(response.status).to eq(422)
      end

      specify 'should create one new user' do
        expect(@users.size).to eq(1)
      end

      specify 'should return json with error' do
        expect(JSON.parse(response.body).symbolize_keys).to eq(
          { error: 'Login has already been taken' }
        )
      end
    end
  end
end
