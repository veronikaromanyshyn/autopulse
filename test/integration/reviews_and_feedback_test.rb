require "test_helper"

class ReviewsAndFeedbackTest < ActionDispatch::IntegrationTest
  setup { @product = create_product }

  test "гість не може залишити відгук" do
    post product_reviews_path(@product), params: { review: { rating: 5, body: "Дуже хороший товар" } }
    assert_redirected_to login_path
  end

  test "авторизований користувач залишає відгук" do
    log_in_as(create_user)
    assert_difference "@product.reviews.count", 1 do
      post product_reviews_path(@product), params: { review: { rating: 4, body: "Підійшло на мою Audi A6" } }
    end
  end

  test "форма зворотного зв'язку зберігає звернення" do
    assert_difference "FeedbackMessage.count", 1 do
      post contacts_path, params: { feedback_message: { name: "Василь", email: "v@example.com",
                                                        subject: "Інше", body: "Чи є знижки для СТО?" } }
    end
    assert_redirected_to contacts_path
  end
end
