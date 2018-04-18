require 'spec_helper'

RSpec.describe Api::V1::UserSessionsController do
  describe 'POST create', type: :request do

    context 'when user is not created' do
      before do
        post(
          '/api/authenticate',
          params: {
            login: 'login',
            password: 'password'
          }
        )

        @user_session = UserSession.first
      end

      specify 'should return status 422' do
        expect(response.status).to eq(422)
      end

      specify 'should not create a user session' do
        expect(@user_session).to be_nil
      end

      specify 'should resturn json with error message' do
        expect(JSON.parse(response.body).symbolize_keys).to eq(
          { error: 'Invalid login or password' }
        )
      end
    end

    context 'when user exists' do
      let!(:user) { create(:user) }

      context 'and credentials is both valid' do
        before do
          post(
            '/api/authenticate',
            params: {
              login: user.login,
              password: 'password'
            }
          )

          @user_session = UserSession.find_by(user: user)
        end

        specify 'should return status 200' do
          expect(response.status).to eq(200)
        end

        specify 'should create user session which expires in 1 day' do
          expect(@user_session).not_to be_nil
          expect(@user_session.expire_at).to(
            be_within(1.second).of(Time.zone.now + 1.day)
          )
        end

        specify 'should return json with auth token' do
          expect(JSON.parse(response.body).symbolize_keys).to eq(
            { auth_key: @user_session.auth_key }
          )
        end
      end

      context 'and login is not valid' do
        before do
          post(
            '/api/authenticate',
            params: {
              login: 'invalid',
              password: 'password'
            }
          )

          @user_session = UserSession.find_by(user: user)
        end

        specify 'should return status 422' do
          expect(response.status).to eq(422)
        end

        specify 'should not create a user session' do
          expect(@user_session).to be_nil
        end

        specify 'should resturn json with error message' do
          expect(JSON.parse(response.body).symbolize_keys).to eq(
            { error: 'Invalid login or password' }
          )
        end
      end

      context 'and password is not valid' do
        before do
          post(
            '/api/authenticate',
            params: {
              login: user.login,
              password: 'invalid'
            }
          )

          @user_session = UserSession.find_by(user: user)
        end

        specify 'should return status 422' do
          expect(response.status).to eq(422)
        end

        specify 'should not create a user session' do
          expect(@user_session).to be_nil
        end

        specify 'should resturn json with error message' do
          expect(JSON.parse(response.body).symbolize_keys).to eq(
            { error: 'Invalid login or password' }
          )
        end
      end
    end
  end
end
