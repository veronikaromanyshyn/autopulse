class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validate :quantity_not_more_than_stock

  def total_price
    product.price * quantity
  end

  private

  def quantity_not_more_than_stock
    return unless product && quantity
    errors.add(:quantity, "перевищує залишок на складі (#{product.stock} шт.)") if quantity > product.stock
  end
end
