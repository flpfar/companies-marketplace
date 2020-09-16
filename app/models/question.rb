class Question < ApplicationRecord
  belongs_to :user
  belongs_to :sale_post
  has_one :answer
end
