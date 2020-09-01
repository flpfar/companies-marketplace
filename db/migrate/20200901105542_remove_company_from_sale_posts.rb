class RemoveCompanyFromSalePosts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :sale_posts, :company, null: false, foreign_key: true
  end
end
