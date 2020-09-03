class Order < ApplicationRecord
  belongs_to :sale_post
  belongs_to :buyer, class_name: 'User'
  belongs_to :seller, class_name: 'User'

  enum status: { in_progress: 0, completed: 10, canceled: 20 }
end
