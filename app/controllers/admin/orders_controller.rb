class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [ :show, :update ]

  def index
    @orders = Order.order(created_at: :desc)
  end

  def show
  end

  def update
    if @order.update(status_params)
      redirect_to admin_order_path(@order), notice: "Status pesanan diperbarui."
    else
      redirect_to admin_order_path(@order), alert: @order.errors.full_messages.to_sentence
    end
  end

  private

  def set_order
    @order = Order.find_by!(number: params[:id])
  end

  def status_params
    params.require(:order).permit(:status)
  end
end
