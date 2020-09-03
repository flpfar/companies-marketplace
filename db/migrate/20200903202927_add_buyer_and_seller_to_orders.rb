class AddBuyerAndSellerToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :buyer, null: false, foreign_key: { to_table: :users }
    add_reference :orders, :seller, null: false, foreign_key: { to_table: :users }
  end
end
