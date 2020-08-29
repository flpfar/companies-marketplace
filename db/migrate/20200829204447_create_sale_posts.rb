class CreateSalePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :sale_posts do |t|
      t.string :title
      t.integer :price
      t.references :user, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
