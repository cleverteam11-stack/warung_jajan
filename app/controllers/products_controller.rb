class ProductsController < ApplicationController
  allow_unauthenticated_access

  def index
    @categories = Category.order(:name)
    @products = Product.active.order(:name)
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
  end

  def show
    @product = Product.active.find_by!(slug: params[:slug])
  end
end
