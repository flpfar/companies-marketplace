class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :social_name, :birth_date, :role, :department, presence: true, on: :update

  after_update :enable_user

  enum status: { disabled: 0, enabled: 1 }

  def enable_user
    enabled! if disabled?
  end
end
