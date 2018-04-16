class Property < ApplicationRecord
  belongs_to :user

  has_one :ownership_transfer_request
  has_many :ownership_transfer_transactions

  before_destroy :check_available_request

  validates :title, presence: true,
    length: { in: 3..32 }

  validates :value, presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  def as_json(options={})
    { id: id, title: title, value: value }
  end

  private

  def check_available_request
    if ownership_transfer_request
      raise StandardError, 'Complete ownership transfer before destroy'
    end
  end
end
