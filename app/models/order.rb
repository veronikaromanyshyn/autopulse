class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :delivery_method
  has_many :order_items, dependent: :destroy

  PAYMENT_METHODS = {
    "card" => "Оплата карткою онлайн",
    "cod"  => "Накладений платіж (при отриманні)"
  }.freeze

  STATUSES = {
    "new"       => "Нове",
    "awaiting"  => "Очікує оплати",
    "paid"      => "Оплачено",
    "shipped"   => "Відправлено",
    "completed" => "Виконано",
    "cancelled" => "Скасовано"
  }.freeze

  validates :full_name, :phone, :email, :city, :address, presence: true
  validates :phone, format: { with: /\A\+?380\d{9}\z/, message: "має бути у форматі +380XXXXXXXXX" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :payment_method, inclusion: { in: PAYMENT_METHODS.keys }
  validates :status, inclusion: { in: STATUSES.keys }

  before_create :assign_number

  scope :recent, -> { order(created_at: :desc) }

  # Переносить позиції з кошика у замовлення та рахує суми
  def build_from_cart(cart)
    cart.cart_items.includes(:product).each do |item|
      order_items.build(product: item.product, quantity: item.quantity, price: item.product.price)
    end
    self.items_total   = order_items.sum { |i| i.price * i.quantity }
    self.delivery_cost = delivery_method ? delivery_method.cost_for(items_total) : 0
    self.total         = items_total + delivery_cost
    self.status        = payment_method == "card" ? "awaiting" : "new"
  end

  # Списує залишки товарів після оформлення
  def reserve_stock!
    order_items.each { |i| i.product&.decrement!(:stock, i.quantity) }
  end

  def mark_paid!(reference, last4)
    update!(status: "paid", paid_at: Time.current, payment_reference: reference, card_last4: last4)
  end

  def paid?        = status == "paid" || paid_at.present?
  def status_name  = STATUSES[status]
  def payment_name = PAYMENT_METHODS[payment_method]

  private

  def assign_number
    self.number = "AP-#{Time.current.strftime('%y%m%d')}-#{SecureRandom.random_number(10_000).to_s.rjust(4, '0')}"
  end
end
