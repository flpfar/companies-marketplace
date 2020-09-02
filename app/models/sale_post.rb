class SalePost < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :orders

  enum status: { enabled: 0, disabled: 10 }

  validates :title, :description, :price, presence: true
end
