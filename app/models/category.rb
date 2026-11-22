class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9\-]+\z/ }

  default_scope { order(:position) }

  def to_param = slug
end
