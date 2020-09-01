class Company < ApplicationRecord
  has_many :categories
  has_many :users
  has_many :sale_posts, through: :users

  validates :name, :domain, presence: true
  validates :domain, uniqueness: true
  validate :domain_must_be_valid

  private

  def domain_must_be_valid
    return if domain.blank? || domain.match(/^((?!-))(xn--)?[a-z0-9][a-z0-9-_]{0,61}
                                            [a-z0-9]{0,1}\.(xn--)?([a-z0-9\-]{1,61}|
                                            [a-z0-9-]{1,30}\.[a-z]{2,})$/x)

    errors.add(:domain, 'não é válido')
  end
end
