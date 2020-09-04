class Order < ApplicationRecord
  belongs_to :sale_post
  belongs_to :buyer, class_name: 'User'
  belongs_to :seller, class_name: 'User'

  after_create :disable_post_and_send_notification

  enum status: { in_progress: 0, completed: 10, canceled: 20 }

  private

  def disable_post_and_send_notification
    sale_post.user.notifications.create(body: "Solicitação de compra pendente em anúncio #{sale_post.title}",
                                        path: "/orders/#{id}")
    sale_post.disabled!
  end
end
