class Like < ApplicationRecord
  belongs_to :micropost, counter_cache: :likes_count
  belongs_to :user
  validates :user_id, { presence: true }
  validates :micropost_id, { presence: true }
end
