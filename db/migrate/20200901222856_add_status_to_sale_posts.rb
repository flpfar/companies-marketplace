class AddStatusToSalePosts < ActiveRecord::Migration[6.0]
  def change
    add_column :sale_posts, :status, :integer, default: 0
  end
end
