require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @cart = Cart.create!
    @product = create_product(price: 700, stock: 10)
    @cart.add_product(@product, 2).save!
    @delivery = create_delivery(price: 80, free_from: 2000)
  end

  def build_order(attrs = {})
    Order.new({ full_name: "Іван Петренко", phone: "+380501234567", email: "ivan@example.com",
                city: "Київ", address: "Відділення №1", delivery_method: @delivery,
                payment_method: "cod" }.merge(attrs)).tap { |o| o.build_from_cart(@cart) }
  end

  test "рахує суму замовлення з доставкою" do
    order = build_order
    assert_equal 1400, order.items_total
    assert_equal 80, order.delivery_cost
    assert_equal 1480, order.total
  end

  test "доставка безкоштовна від порогової суми" do
    @cart.add_product(@product, 1).save!
    assert_equal 0, build_order.delivery_cost
  end

  test "оплата карткою переводить замовлення в статус очікування оплати" do
    assert_equal "awaiting", build_order(payment_method: "card").status
  end

  test "номер замовлення генерується автоматично" do
    order = build_order
    order.save!
    assert_match(/\AAP-\d{6}-\d{4}\z/, order.number)
  end

  test "оформлення списує залишки товару" do
    order = build_order
    order.save!
    order.reserve_stock!
    assert_equal 8, @product.reload.stock
  end

  test "без телефону замовлення невалідне" do
    assert_not build_order(phone: "").valid?
  end
end
