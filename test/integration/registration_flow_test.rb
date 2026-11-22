require "test_helper"

class RegistrationFlowTest < ActionDispatch::IntegrationTest
  test "реєстрація нового користувача та автоматичний вхід" do
    assert_difference "User.count", 1 do
      post signup_path, params: { user: { name: "Олена", email: "olena@example.com", phone: "",
                                          password: "secret123", password_confirmation: "secret123" } }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_select ".user-nav", /Олена/
  end

  test "реєстрація з помилками показує повідомлення" do
    assert_no_difference "User.count" do
      post signup_path, params: { user: { name: "", email: "bad", password: "1", password_confirmation: "2" } }
    end
    assert_response :unprocessable_entity
    assert_select ".form-errors"
  end

  test "вхід і вихід" do
    user = create_user
    log_in_as(user)
    assert_redirected_to root_path
    delete logout_path
    assert_nil session[:user_id]
  end

  test "невірний пароль не дозволяє увійти" do
    log_in_as(create_user, password: "wrong")
    assert_response :unprocessable_entity
    assert_select ".flash-alert", /Невірний email або пароль/
  end
end
