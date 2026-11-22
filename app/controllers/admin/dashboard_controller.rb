module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        products: Product.count,
        orders:   Order.count,
        revenue:  Order.where(status: %w[paid shipped completed]).sum(:total),
        users:    User.count,
        feedback: FeedbackMessage.where(status: "new").count
      }
      @recent_orders = Order.recent.limit(5)
      @low_stock = Product.where("stock < 5").order(:stock).limit(5)
    end
  end
end
