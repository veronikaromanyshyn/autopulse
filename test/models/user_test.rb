require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "валідний користувач зберігається" do
    assert create_user.persisted?
  end

  test "email має бути унікальним без урахування регістру" do
    create_user(email: "same@example.com")
    dup = User.new(name: "Інший", email: "SAME@example.com", password: "secret123")
    assert_not dup.valid?
    assert_includes dup.errors[:email], "вже використовується"
  end

  test "email приводиться до нижнього регістру" do
    assert_equal "mixed@example.com", create_user(email: "MiXeD@Example.com").email
  end

  test "пароль коротший за 6 символів недопустимий" do
    user = User.new(name: "А", email: "a@example.com", password: "123")
    assert_not user.valid?
  end

  test "телефон перевіряється за українським форматом" do
    assert_not User.new(name: "А", email: "b@example.com", password: "secret123", phone: "12345").valid?
    assert User.new(name: "А", email: "c@example.com", password: "secret123", phone: "+380501234567").valid?
  end

  test "authenticate повертає користувача лише з правильним паролем" do
    user = create_user
    assert user.authenticate("secret123")
    assert_not user.authenticate("wrong")
  end
end
