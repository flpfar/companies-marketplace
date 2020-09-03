class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  has_many :sale_posts
  has_many :notifications

  validates :name, :social_name, :birth_date, :role, :department, presence: true, on: :update

  before_validation :assign_company_by_email

  def enabled?
    name.present?
  end

  private

  def assign_company_by_email
    domain = email.split('@')[1]
    company_found = Company.find_by(domain: domain)
    if company_found
      self.company = company_found
    else
      errors.add(:company, 'não encontrada. Certifique-se de utilizar um email com domínio da empresa no cadastro')
    end
  end
end
