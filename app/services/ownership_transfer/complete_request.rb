class OwnershipTransfer::CompleteRequest
  class << self
    def call(request)
      ActiveRecord::Base.transaction do
        property = request.property.lock!

        property.update!(user: request.recipient)

        OwnershipTransferTransaction.create!(
          initiator: request.initiator,
          recipient: request.recipient,
          property: property,
          requested_at: request.requested_at,
          completed_at: Time.zone.now
        )

        request.destroy!
      end
    end
  end
end
