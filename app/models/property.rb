class Property < ApplicationRecord
  belongs_to :user

  has_one :ownership_transfer_requests
  has_many :ownership_transfer_transactions

  validates :title, presence: true, length: { in: 3..32 }
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def as_json(options={})
    { id: id, title: title, value: value }
  end
end
