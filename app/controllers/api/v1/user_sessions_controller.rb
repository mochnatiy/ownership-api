module Api
  module V1
    class UserSessionsController < ApplicationController
      # POST /api/authenticate
      def create
        user = User.find_by(login: params[:login])

        if user && user.password_hash == Digest::MD5.hexdigest(params[:password])
          session = UserSession.create!(user: user)

          render status: 200, json: {
            success: true,
            auth_key: session.auth_key
          }
        else
          render status: 422, json: {
            success: false,
            error: 'Invalid login or password'
          }
        end
      end
    end
  end
end
