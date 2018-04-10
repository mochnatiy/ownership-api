class OwnershipTransferRequest < ApplicationRecord
  belongs_to :property
  belongs_to :initiator, class_name: 'User', foreign_key: :initiator_id
  belongs_to :recipient, class_name: 'User', foreign_key: :recipient_id

  validates :transfer_key, presence: true
  validates :requested_at, presence: true

  before_validation :set_requested_at, :set_transfer_key

  private

  def set_requested_at
    self.requested_at = Time.zone.now if self.requested_at.blank?
  end

  def set_transfer_key
    self.transfer_key = Digest::SHA1.hexdigest(
      property.title << recipient.login << requested_at.to_i.to_s
    ) if self.transfer_key.blank?
  end
end
