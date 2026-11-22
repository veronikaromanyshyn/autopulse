class PaymentsController < ApplicationController
  before_action :set_order

  def new
    redirect_to @order, notice: "Замовлення вже оплачено" if @order.paid?
  end

  def create
    result = PaymentGateway.charge(
      order: @order, number: params[:card_number], exp_month: params[:exp_month],
      exp_year: params[:exp_year], cvv: params[:cvv]
    )
    if result.success?
      @order.mark_paid!(result.reference, result.last4)
      redirect_to @order, notice: "Оплату успішно проведено. Номер транзакції: #{result.reference}"
    else
      flash.now[:alert] = result.error
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = find_accessible_order(params[:order_id])
  end
end
