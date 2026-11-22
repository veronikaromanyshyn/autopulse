class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :rating, inclusion: { in: 1..5, message: "має бути від 1 до 5" }
  validates :body, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :user_id, uniqueness: { scope: :product_id, message: "вже залишив відгук на цей товар" }

  default_scope { order(created_at: :desc) }
end
