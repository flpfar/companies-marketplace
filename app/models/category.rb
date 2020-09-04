class Category < ApplicationRecord
  belongs_to :company
  has_many :sale_posts
end
