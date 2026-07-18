class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.order(:name)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_product_path(@product), notice: "Produk berhasil ditambahkan."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: "Produk berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Produk berhasil dihapus."
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to admin_products_path, alert: "Produk tidak bisa dihapus karena sudah pernah dipesan. Ubah status jadi \"discontinued\" saja."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price_cents, :stock, :status, :category_id, :photo)
  end
end
