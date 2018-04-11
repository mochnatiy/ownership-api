class User < ApplicationRecord
  has_one :user_session, dependent: :destroy

  has_many :properties

  has_many :incoming_requests,
    class_name: 'OwnershipTransferRequest',
    foreign_key: :recipient_id

  has_many :outgoing_requests,
    class_name: 'OwnershipTransferRequest',
    foreign_key: :initiator_id

  has_many :incoming_transactions,
    class_name: 'OwnershipTransferTransaction',
    foreign_key: :recipient_id

  has_many :outgoing_transactions,
    class_name: 'OwnershipTransferTransaction',
    foreign_key: :initiator_id

  attr_accessor :password

  validates :login, presence: true, uniqueness: true, length: { in: 3..32 }
  validates :password, presence: true, length: { in: 8..20 }
  validates :password_hash, presence: true

  before_validation :encrypt_password

  private

  def encrypt_password
    if self.password_hash.blank?
      self.password_hash = Digest::MD5.hexdigest(password)
    end
  end
end
