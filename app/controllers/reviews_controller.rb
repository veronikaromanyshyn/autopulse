class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_product

  def create
    @review = @product.reviews.build(review_params.merge(user: current_user))
    if @review.save
      redirect_to product_path(@product, anchor: "reviews"), notice: "Дякуємо за відгук!"
    else
      @reviews = @product.reviews.includes(:user)
      @related = Product.where(category: @product.category).where.not(id: @product.id).limit(4)
      render "products/show", status: :unprocessable_entity
    end
  end

  def destroy
    review = @product.reviews.find(params[:id])
    if review.user == current_user || admin?
      review.destroy
      redirect_to product_path(@product, anchor: "reviews"), notice: "Відгук видалено"
    else
      redirect_to @product, alert: "Недостатньо прав"
    end
  end

  private

  def set_product = @product = Product.find(params[:product_id])

  def review_params = params.require(:review).permit(:rating, :body)
end
