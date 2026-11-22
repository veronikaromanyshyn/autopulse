class ApplicationController < ActionController::Base
  include Authentication
  include CurrentCart

  before_action :load_categories

  private

  # Замовлення доступне власнику, адміну або гостю, що щойно його оформив
  def find_accessible_order(id)
    order = Order.find(id)
    allowed = admin? || (order.user && order.user == current_user) ||
              (order.user.nil? && session[:last_order_id] == order.id)
    raise ActiveRecord::RecordNotFound unless allowed
    order
  end

  def load_categories
    @nav_categories = Category.all
  end
end
