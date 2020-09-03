class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :status, default: 0
      t.string :body
      t.string :path
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
