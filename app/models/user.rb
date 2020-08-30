class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company

  enum status: { disabled: 0, enabled: 1 }

  validates :name, :social_name, :birth_date, :role, :department, presence: true, on: :update

  before_validation :assign_company_by_email
  after_update :enable_user

  private

  def assign_company_by_email
    domain = email.split('@')[1]
    company_found = Company.find_by(domain: domain)
    if company_found
      self.company = company_found
    else
      errors.add(:company, 'não encontrada')
    end
  end

  def enable_user
    enabled! if disabled?
  end
end
