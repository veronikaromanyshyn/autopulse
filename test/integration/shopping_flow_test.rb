require "test_helper"

class ShoppingFlowTest < ActionDispatch::IntegrationTest
  setup do
    @product = create_product(name: "Колодки TRW", price: 1200, stock: 5)
    @delivery = create_delivery(price: 80, free_from: 5000)
  end

  test "каталог і сторінка товару відкриваються" do
    get root_path
    assert_response :success
    assert_select ".card h3", /Колодки TRW/
    get product_path(@product)
    assert_select "h1", "Колодки TRW"
  end

  test "повний цикл: кошик → замовлення → оплата карткою" do
    post cart_items_path, params: { product_id: @product.id, quantity: 2 }
    get cart_path
    assert_select ".cart-table tbody tr", 1

    assert_difference "Order.count", 1 do
      post orders_path, params: { order: { full_name: "Іван Петренко", phone: "+380501234567",
                                           email: "ivan@example.com", city: "Львів", address: "Відділення №3",
                                           delivery_method_id: @delivery.id, payment_method: "card" } }
    end
    order = Order.last
    assert_redirected_to new_order_payment_path(order)
    assert_equal 2480, order.total
    assert_equal 3, @product.reload.stock

    post order_payment_path(order), params: { card_number: "4242424242424242", exp_month: "12",
                                              exp_year: (Date.current.year + 1).to_s[-2..], cvv: "123" }
    assert_redirected_to order_path(order)
    assert order.reload.paid?
    assert_equal "4242", order.card_last4
  end

  test "оформлення з порожнім кошиком неможливе" do
    get new_order_path
    assert_redirected_to cart_path
  end

  test "чуже замовлення недоступне" do
    order = Order.create!(full_name: "Х", phone: "+380501234567", email: "x@example.com", city: "Київ",
                          address: "1", delivery_method: @delivery, payment_method: "cod",
                          items_total: 0, delivery_cost: 0, total: 0, user: create_user)
    assert_raises(ActiveRecord::RecordNotFound) { get order_path(order) }
  end
end
