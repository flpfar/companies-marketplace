class SalePost < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, :description, :price, presence: true
end
