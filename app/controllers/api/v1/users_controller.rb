module Api
  module V1
    class UsersController < ApplicationController
      # POST /api/register.json

      # params:
      # login (string)
      # password (string)
      def create
        user = User.new(login: params[:login], password: params[:password])

        if user.save
          render status: 200, json: { user_id: user.id }
        else
          render status: 422, json: {
            error: user.errors.full_messages.join(', ')
          }
        end
      end
    end
  end
end
