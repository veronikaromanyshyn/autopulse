require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  test "оцінка має бути від 1 до 5" do
    review = Review.new(product: create_product, user: create_user, rating: 6, body: "Текст відгуку достатньої довжини")
    assert_not review.valid?
  end

  test "один користувач — один відгук на товар" do
    product = create_product
    user = create_user
    Review.create!(product: product, user: user, rating: 5, body: "Перший відгук про товар")
    assert_not Review.new(product: product, user: user, rating: 4, body: "Другий відгук про товар").valid?
  end
end
