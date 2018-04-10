class CreateUserSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_sessions do |t|
      t.integer :user_id, null: false, foreign_key: true
      t.string :auth_key, null: false

      t.datetime :expire_at, null: false

      t.timestamps

      t.index [:user_id], unique: true
    end
  end
end
