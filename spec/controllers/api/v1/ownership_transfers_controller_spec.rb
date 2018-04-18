require 'spec_helper'

RSpec.describe Api::V1::OwnershipTransfersController do
  describe 'POST request_operation', type: :request do
    let!(:initiator) { create(:user, login: 'bob', password: 'password1') }
    let!(:recipient) { create(:user, login: 'alice', password: 'password2') }
    let!(:property) { create(:property, user: initiator) }

    # Assume that initiator already authenticated
    let!(:session) { create(:user_session, user: initiator) }

    context 'when user session is expired' do
      before do
        session.update!(expire_at: Time.zone.now - 1.day)

        post(
          '/api/ownership_transfers/request_operation',
          params: {
            auth_key: session.auth_key,
            recipient_login: recipient.login,
            property_id: property.id
          }
        )
      end

      specify 'should return status 422' do
        expect(response.status).to eq(422)
      end

      specify 'should return json with error' do
        expect(JSON.parse(response.body).symbolize_keys).to eq(
          { error: 'Your session is expired, please authenticate' }
        )
      end
    end

    context 'when all data is valid' do
      before do
        post(
          '/api/ownership_transfers/request_operation',
          params: {
            auth_key: session.auth_key,
            recipient_login: recipient.login,
            property_id: property.id
          }
        )

        @transaction_request = initiator.
          outgoing_requests.
          find_by(property: property)
      end

      specify 'should return status 200' do
        expect(response.status).to eq(200)
      end

      specify 'should create one transaction request' do
        expect(@transaction_request).to_not be_nil
        expect(initiator.outgoing_requests.size).to eq(1)
        expect(@transaction_request.requested_at).to(
          be_within(1.second).of Time.zone.now
        )
      end

      specify 'should return json with valid transfer_key' do
        expect(JSON.parse(response.body).symbolize_keys).to eql({
          transfer_key: @transaction_request.transfer_key
        })
      end
    end
  end

  describe 'POST complete_operation', type: :request do
    let!(:initiator) { create(:user, login: 'mike', password: 'password1') }
    let!(:recipient) { create(:user, login: 'shannon', password: 'password2') }
    let!(:property) { create(:property, user: initiator) }

    # Assume that recipient already authenticated
    let!(:session) { create(:user_session, user: recipient) }

    # Assume that we have request to make a transfer
    let!(:transfer_request) do
      create(:ownership_transfer_request,
        initiator: initiator,
        recipient: recipient,
        property: property
      )
    end

    context 'when all data is valid' do
      before do
        post(
          '/api/ownership_transfers/complete_operation',
          params: {
            auth_key: session.auth_key,
            transfer_key: transfer_request.transfer_key,
            property_id: property.id
          }
        )

        @transaction = recipient.
          incoming_transactions.
          find_by(property: property)

        property.reload
      end

      specify 'should return status 200' do
        expect(response.status).to eq(200)
      end

      specify 'should create one transaction request' do
        expect(@transaction).to_not be_nil
        expect(recipient.incoming_transactions.size).to eq(1)
        expect(@transaction.completed_at).to(
          be_within(1.second).of Time.zone.now
        )
      end

      specify 'should return success json' do
        expect(JSON.parse(response.body).symbolize_keys).to eql({
          success: true
        })
      end

      specify 'should transfer ownership to recipient' do
        expect(property.user_id).to eq(recipient.id)
      end
    end
  end
end
