class Notification < ApplicationRecord
  belongs_to :user

  enum status: { unseen: 0, seen: 10 }
end
