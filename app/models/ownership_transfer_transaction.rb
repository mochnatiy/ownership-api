class OwnershipTransferTransaction < ApplicationRecord
  belongs_to :property
  belongs_to :initiator, class_name: 'User', foreign_key: :initiator_id
  belongs_to :recipient, class_name: 'User', foreign_key: :recipient_id

  validates :requested_at, presence: true
  validates :completed_at, presence: true

  before_create :set_completed_at

  private

  def set_completed_at
    self.completed_at = Time.zone.now
  end
end
