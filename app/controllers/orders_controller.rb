class OrdersController < ApplicationController
  before_action :require_login, only: [:index]
  before_action :ensure_cart_not_empty, only: [:new, :create]

  def index
    @orders = current_user.orders.recent.includes(:delivery_method)
  end

  def new
    @order = Order.new(
      full_name: current_user&.name, email: current_user&.email, phone: current_user&.phone,
      delivery_method: DeliveryMethod.first, payment_method: "card"
    )
    prepare_summary
  end

  def create
    @order = Order.new(order_params.merge(user: current_user))
    @order.build_from_cart(current_cart)

    if @order.valid? && Order.transaction { @order.save! && @order.reserve_stock! }
      current_cart.cart_items.destroy_all
      session[:last_order_id] = @order.id
      if @order.payment_method == "card"
        redirect_to new_order_payment_path(@order)
      else
        redirect_to @order, notice: "Замовлення #{@order.number} оформлено! Очікуйте дзвінка менеджера."
      end
    else
      prepare_summary
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @order = find_accessible_order(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:full_name, :phone, :email, :city, :address, :comment,
                                  :delivery_method_id, :payment_method)
  end

  def prepare_summary
    @items = current_cart.cart_items.includes(:product)
    @delivery_methods = DeliveryMethod.all
  end

  def ensure_cart_not_empty
    redirect_to cart_path, alert: "Кошик порожній" if current_cart.empty?
  end
end
