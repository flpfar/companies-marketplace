class RemoveSocialNameFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :social_name, :string
  end
end
