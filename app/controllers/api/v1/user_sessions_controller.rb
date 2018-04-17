module Api
  module V1
    class UserSessionsController < ApplicationController
      # POST /api/authenticate

      # params:
      # login (string)
      # password (string)
      def create
        user = User::FindForAuthenticate.call(params)

        render(
          status: 422,
          json: { error: 'Invalid login or password' }
        ) and return unless user

        begin
          session = UserSession.create!(user: user)
          render status: 200, json: { auth_key: session.auth_key }
        rescue ActiveRecord::RecordNotUnique
          render status: 422, json: { error: 'You already logged in' }
        end
      end

      # TODO:
      # def destroy
      # end
    end
  end
end
