module Api
  module V1
    class OwnershipTransfersController < ApplicationController
      respond_to :json

      before_action :check_token

      # POST /api/ownership_transfers/request_operation

      # params:
      # auth_key (string)
      # recipient_login (string)
      # property_id (integer)
      def request_operation
        recipient = User.find_by(login: params[:recipient_login])

        render status: 404, json: {
          error: 'Recipient does not exist'
        } and return if recipient.nil?

        property = Property.find_by(
          id: params[:property_id], user: current_user
        )

        render status: 404, json: {
          error: 'Property doesn\'t belongs to you or doesn\'t exist'
        } and return if property.nil?

        begin
          request = OwnershipTransferRequest.create!(
            initiator: current_user,
            recipient: recipient,
            property: property
          )

          render status: 200, json: { transfer_key: request.transfer_key }
        rescue StandardError => e
          render status: 422, json: { success: false, error: e.message }
        end
      end

      # POST /api/ownership_transfers/complete_operation

      # params:
      # auth_key (string)
      # transfer_key (string)
      # property_id (integer)
      def complete_operation
        transfer_request = OwnershipTransferRequest.find_by(
          transfer_key: params[:transfer_key]
        )

        if transfer_request.nil? || transfer_request.recipient != current_user
          render status: 404, json: {
            error: 'Invalid key or you don\'t have property to receive'
          } and return
        end

        begin
          OwnershipTransfer::CompleteRequest.call(transfer_request)

          render status: 200, json: { success: true }
        rescue StandardError => e
          render status: 422, json: { error: e.message }
        end
      end
    end
  end
end
