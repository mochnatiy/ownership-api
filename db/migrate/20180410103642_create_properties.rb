class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :properties do |t|
      t.integer :user_id, null: false, foreign_key: true, index: true
      t.string :title, null: false
      t.integer :value, null: false

      t.timestamps
    end
  end
end
