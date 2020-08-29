class AddInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :social_name, :string
    add_column :users, :birth_date, :date
    add_column :users, :role, :string
    add_column :users, :department, :string
    add_column :users, :status, :integer, default: 0
  end
end
