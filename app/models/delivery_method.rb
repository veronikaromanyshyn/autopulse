class DeliveryMethod < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error

  validates :name, :code, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  default_scope { order(:position) }

  # Вартість доставки з урахуванням порогу безкоштовної доставки
  def cost_for(amount)
    return 0 if free_from.present? && amount >= free_from
    price
  end

  def requires_address?
    code == "courier"
  end
end
