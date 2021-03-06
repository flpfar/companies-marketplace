class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  has_many :sale_posts
  has_many :notifications
  has_many :sale_orders, class_name: 'Order', foreign_key: 'seller_id'
  has_many :buy_orders, class_name: 'Order', foreign_key: 'buyer_id'

  validates :name, :birth_date, :role, :department, presence: true, on: :update

  before_validation :assign_company_by_email, on: :create

  def enabled?
    name.present?
  end

  def buying_order_in_progress_at_sale_post(post)
    buy_orders.find_by(sale_post: post, status: :in_progress)
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
