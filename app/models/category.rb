class Category < ApplicationRecord
  belongs_to :company
  has_many :sale_posts

  validates :name, presence: true
end
