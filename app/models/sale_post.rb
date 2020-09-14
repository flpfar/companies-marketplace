class SalePost < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :cover

  enum status: { enabled: 0, disabled: 10, sold: 20 }

  validates :title, :description, :price, presence: true
end
