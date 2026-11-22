class ProductsController < ApplicationController
  PER_PAGE = 12

  def index
    @category = Category.find_by!(slug: params[:category]) if params[:category]
    scope = Product.includes(:category).search(params[:q])
    scope = scope.where(category: @category) if @category
    scope = scope.where(brand: params[:brand]) if params[:brand].present?
    scope = scope.in_stock if params[:in_stock] == "1"
    @brands   = Product.distinct.order(:brand).pluck(:brand)
    @page     = [params[:page].to_i, 1].max
    @total    = scope.count
    @products = scope.sorted(params[:sort]).offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
    @pages    = (@total / PER_PAGE.to_f).ceil
    @featured = Product.featured.limit(4) if @category.nil? && params[:q].blank? && @page == 1
  end

  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews.includes(:user)
    @review  = @product.reviews.build
    @related = Product.where(category: @product.category).where.not(id: @product.id).limit(4)
  end
end
