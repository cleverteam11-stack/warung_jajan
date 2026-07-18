class CartItemsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_product

  def create
    current_cart.add(@product.id, params[:quantity].presence || 1)
    redirect_to cart_path, notice: "#{@product.name} ditambahkan ke keranjang."
  end

  def update
    current_cart.update_quantity(@product.id, params[:quantity])
    redirect_to cart_path
  end

  def destroy
    current_cart.remove(@product.id)
    redirect_to cart_path
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
end
