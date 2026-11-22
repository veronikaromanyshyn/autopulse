require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "ціна має бути додатною" do
    product = Product.new(category: create_category, name: "X", brand: "B", sku: "S1", price: 0)
    assert_not product.valid?
    assert product.errors[:price].any?
  end

  test "стара ціна повинна бути більшою за поточну" do
    product = create_product(price: 500)
    product.old_price = 400
    assert_not product.valid?
  end

  test "розраховує відсоток знижки" do
    assert_equal 20, create_product(price: 800, old_price: 1000).discount_percent
  end

  test "пошук знаходить товар за сумісністю з авто" do
    hit = create_product(compatibility: "Audi A6 C7")
    create_product(compatibility: "VW Golf")
    assert_equal [hit], Product.search("audi a6").to_a
  end

  test "середній рейтинг рахується за відгуками" do
    product = create_product
    Review.create!(product: product, user: create_user, rating: 5, body: "Чудовий товар, рекомендую")
    Review.create!(product: product, user: create_user, rating: 4, body: "Добрий товар за свої гроші")
    assert_equal 4.5, product.average_rating
  end
end
