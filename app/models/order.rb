class Order < ApplicationRecord
  belongs_to :sale_post
  belongs_to :buyer, class_name: 'User'
  belongs_to :seller, class_name: 'User'
  has_many :messages

  validates_uniqueness_of :sale_post, scope: :buyer, conditions: -> { where(status: :in_progress) }

  after_create :send_notification

  enum status: { in_progress: 0, completed: 10, canceled: 20 }

  private

  def send_notification
    sale_post.user.notifications.create(body: "Solicitação de compra pendente em anúncio #{sale_post.title}",
                                        path: "/orders/#{id}")
  end
end
