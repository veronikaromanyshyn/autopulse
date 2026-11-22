module CurrentCart
  extend ActiveSupport::Concern

  included do
    helper_method :current_cart
  end

  private

  # Кошик зберігається в БД, а його id — у сесії, тож працює і для гостей
  def current_cart
    @current_cart ||= Cart.find_by(id: session[:cart_id]) || create_cart
  end

  def create_cart
    Cart.create!.tap { |cart| session[:cart_id] = cart.id }
  end
end
