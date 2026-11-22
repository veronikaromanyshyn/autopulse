module Admin
  class ProductsController < BaseController
    before_action :set_product, only: [:edit, :update, :destroy]

    def index
      @products = Product.includes(:category).search(params[:q]).order(:category_id, :name)
    end

    def new
      @product = Product.new(stock: 10)
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to admin_products_path, notice: "Товар «#{@product.name}» додано"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @product.update(product_params)
        redirect_to admin_products_path, notice: "Товар оновлено"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: "Товар видалено"
    end

    private

    def set_product = @product = Product.find(params[:id])

    def product_params
      params.require(:product).permit(:category_id, :name, :brand, :sku, :description, :price,
                                      :old_price, :stock, :image, :compatibility, :featured)
    end
  end
end
