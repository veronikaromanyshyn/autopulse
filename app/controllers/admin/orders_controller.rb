module Admin
  class OrdersController < BaseController
    def index
      @orders = Order.recent.includes(:delivery_method, :user)
      @orders = @orders.where(status: params[:status]) if params[:status].present?
    end

    def show
      @order = Order.find(params[:id])
    end

    def update
      @order = Order.find(params[:id])
      @order.update!(status: params.require(:order)[:status])
      redirect_to admin_order_path(@order), notice: "Статус змінено на «#{@order.status_name}»"
    end
  end
end
