class OrdersController < ApplicationController
  allow_unauthenticated_access

  def new
    if current_cart.empty?
      redirect_to cart_path, alert: "Keranjang masih kosong."
      return
    end

    @order = Order.new
  end

  def create
    if current_cart.empty?
      redirect_to cart_path, alert: "Keranjang masih kosong."
      return
    end

    @order = Order.checkout!(cart: current_cart.to_h, **order_params.to_h.symbolize_keys)
    current_cart.clear
    redirect_to order_path(@order)
  rescue Order::InsufficientStock => e
    redirect_to cart_path, alert: e.message
  rescue ActiveRecord::RecordInvalid => e
    @order = e.record
    flash.now[:alert] = @order.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
  end

  def show
    @order = Order.find_by!(number: params[:number])
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :customer_phone, :customer_address, :payment_method)
  end
end
