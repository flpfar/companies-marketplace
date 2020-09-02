class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :item_name
      t.string :item_description
      t.integer :posted_price
      t.integer :final_price
      t.references :sale_post, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
