class Comment < ApplicationRecord
  belongs_to :sale_post
  belongs_to :user
end
