ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  parallelize(workers: 1)

  # Фабричні методи для створення тестових даних
  def create_category(attrs = {})
    Category.create!({ name: "Фільтри", slug: "filters-#{SecureRandom.hex(3)}", position: 1 }.merge(attrs))
  end

  def create_product(attrs = {})
    Product.create!({ category: attrs.delete(:category) || create_category, name: "Фільтр масляний MANN",
                      brand: "MANN", sku: "SKU-#{SecureRandom.hex(4)}", price: 250, stock: 10,
                      description: "Тестовий товар" }.merge(attrs))
  end

  def create_user(attrs = {})
    User.create!({ name: "Тест Користувач", email: "user#{SecureRandom.hex(3)}@example.com",
                   password: "secret123" }.merge(attrs))
  end

  def create_delivery(attrs = {})
    DeliveryMethod.create!({ name: "Нова пошта", code: "np-#{SecureRandom.hex(3)}", price: 80,
                             free_from: 2000, position: 1 }.merge(attrs))
  end
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, password: "secret123")
    post login_path, params: { email: user.email, password: password }
  end
end
