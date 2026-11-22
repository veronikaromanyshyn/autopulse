class CartItemsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    return redirect_back(fallback_location: product, alert: "Товару немає в наявності") unless product.in_stock?

    item = current_cart.add_product(product, params.fetch(:quantity, 1))
    if item.save
      redirect_back fallback_location: cart_path, notice: "«#{product.name}» додано до кошика"
    else
      redirect_back fallback_location: product, alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = current_cart.cart_items.find(params[:id])
    if item.update(quantity: params[:quantity])
      redirect_to cart_path
    else
      redirect_to cart_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_cart.cart_items.find(params[:id]).destroy
    redirect_to cart_path, notice: "Товар видалено з кошика"
  end
end
