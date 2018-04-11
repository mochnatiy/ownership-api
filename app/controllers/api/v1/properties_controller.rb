module Api
  module V1
    class PropertiesController < ApplicationController
      before_action :check_token

      # GET /api/properties
      def index
        properties = current_user.properties

        if properties.any?
          render status: 200, json: {
            success: true,
            properties: properties.to_json
          }
        else
          render status: 404, json: {
            success: true,
            error: 'You have no properties'
          }
        end
      end

      # POST /api/properites
      def create
        property = current_user.properties.new(
          title: params[:title],
          value: params[:value]
        )

        if property.save
          render status: 200, json: {
            success: true,
            property_id: property.id
          }
        else
          render status: 422, json: {
            success: false,
            error: property.errors.full_messages.join(', ')
          }
        end
      end
    end
  end
end
