class AddCompanyToSalePosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :sale_posts, :company, null: false, foreign_key: true
  end
end
