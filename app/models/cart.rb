class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # Додає товар у кошик або збільшує кількість, якщо він уже є
  def add_product(product, quantity = 1)
    item = cart_items.find_or_initialize_by(product: product)
    item.quantity = item.new_record? ? quantity.to_i : item.quantity + quantity.to_i
    item.quantity = [item.quantity, product.stock].min
    item
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def total_price
    cart_items.includes(:product).sum(&:total_price)
  end

  def empty?
    cart_items.empty?
  end
end
