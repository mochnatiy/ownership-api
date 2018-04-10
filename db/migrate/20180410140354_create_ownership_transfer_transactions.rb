class CreateOwnershipTransferTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :ownership_transfer_transactions do |t|
      t.integer :initiator_id, null: false, foreign_key: true
      t.integer :recipient_id, null: false, foreign_key: true
      t.integer :property_id, null: false, foreign_key: true

      t.datetime :requested_at, null: false
      t.datetime :completed_at, null: false

      t.timestamps
    end
  end
end
