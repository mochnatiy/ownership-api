module Api
  module V1
    class PropertiesController < ApplicationController
      before_action :check_token

      # GET /api/properties

      # params:
      # auth_key (string)
      def index
        properties = current_user.properties

        if properties.any?
          render status: 200, json: { properties: properties.to_json }
        else
          render status: 404, json: { error: 'You have no properties' }
        end
      end

      # POST /api/properites

      # params:
      # title (string)
      # value (integer)
      # auth_key (string)
      def create
        property = current_user.properties.new(
          title: params[:title],
          value: params[:value]
        )

        if property.save
          render status: 200, json: { property_id: property.id }
        else
          render status: 422, json: {
            error: property.errors.full_messages.join(', ')
          }
        end
      end

      # :nodoc:
      # DELETE /api/properites

      # params:
      # property_id (integer)
      # auth_key (string)
      def destroy
        property = current_user.properties.find_by(id: params[:property_id])

        render(
          status: 422,
          json: { error: 'You are not an owner of this property' }
        ) and return unless property

        property.destroy

        if property.destroyed?
          render status: 200, json: { property_id: params[:property_id] }
        else
          render status: 422, json: {
            error: property.errors.full_messages.join(', ')
          }
        end
      end
    end
  end
end
