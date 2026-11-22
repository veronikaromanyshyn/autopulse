require "test_helper"

class AdminTest < ActionDispatch::IntegrationTest
  setup do
    @admin = create_user(admin: true)
    @category = create_category
  end

  test "звичайний користувач не має доступу до адмінки" do
    log_in_as(create_user)
    get admin_products_path
    assert_redirected_to root_path
  end

  test "адміністратор додає новий товар" do
    log_in_as(@admin)
    assert_difference "Product.count", 1 do
      post admin_products_path, params: { product: { category_id: @category.id, name: "Акумулятор VARTA",
                                                     brand: "VARTA", sku: "VAR-1", price: 4290, stock: 3 } }
    end
    assert_redirected_to admin_products_path
  end

  test "адміністратор змінює статус замовлення" do
    log_in_as(@admin)
    order = Order.create!(full_name: "Х", phone: "+380501234567", email: "x@example.com", city: "Київ",
                          address: "1", delivery_method: create_delivery, payment_method: "cod",
                          items_total: 0, delivery_cost: 0, total: 0)
    patch admin_order_path(order), params: { order: { status: "shipped" } }
    assert_equal "shipped", order.reload.status
  end
end
