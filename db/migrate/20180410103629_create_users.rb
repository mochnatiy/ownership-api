class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :login, null: false, index: true
      t.string :password_hash, null: false

      t.timestamps
    end
  end
end
