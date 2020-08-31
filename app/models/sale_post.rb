class SalePost < ApplicationRecord
  belongs_to :user
  belongs_to :company
  belongs_to :category

  validates :title, :description, :price, presence: true

  before_validation :assign_company

  private

  def assign_company
    self.company = user.company
  end
end
