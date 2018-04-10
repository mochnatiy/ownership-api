class CreateOwnershipTransferRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :ownership_transfer_requests do |t|
      t.integer :initiator_id, null: false, foreign_key: true
      t.integer :recipient_id, null: false, foreign_key: true
      t.integer :property_id, null: false, foreign_key: true

      t.string :transfer_key, null: false

      t.datetime :requested_at, null: false

      t.timestamps

      t.index [:property_id], unique: true
    end
  end
end
