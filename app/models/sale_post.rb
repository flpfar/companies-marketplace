class SalePost < ApplicationRecord
  belongs_to :user
  belongs_to :company

  before_validation :assign_company

  private

  def assign_company
    self.company = user.company
  end
end
