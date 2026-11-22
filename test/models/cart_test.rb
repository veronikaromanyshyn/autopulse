require "test_helper"

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = Cart.create!
    @product = create_product(price: 300, stock: 5)
  end

  test "повторне додавання збільшує кількість" do
    @cart.add_product(@product, 2).save!
    @cart.add_product(@product, 1).save!
    assert_equal 1, @cart.cart_items.count
    assert_equal 3, @cart.total_items
  end

  test "кількість не перевищує залишок на складі" do
    @cart.add_product(@product, 10).save!
    assert_equal 5, @cart.total_items
  end

  test "загальна вартість кошика" do
    @cart.add_product(@product, 2).save!
    @cart.add_product(create_product(price: 150), 1).save!
    assert_equal 750, @cart.total_price
  end
end
