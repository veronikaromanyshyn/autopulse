class CartsController < ApplicationController
  def show
    @items = current_cart.cart_items.includes(product: :category)
    @delivery_methods = DeliveryMethod.all
  end

  def destroy
    current_cart.cart_items.destroy_all
    redirect_to cart_path, notice: "Кошик очищено"
  end
end
