class Admin::DashboardController < Admin::BaseController
  def index
    @pending_orders_count = Order.where(status: "pending").count
    @products_count = Product.active.count
    @recent_orders = Order.order(created_at: :desc).limit(10)
  end
end
