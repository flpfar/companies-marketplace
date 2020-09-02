class Order < ApplicationRecord
  belongs_to :sale_post

  enum status: { in_progress: 0, completed: 10, canceled: 20 }
end
