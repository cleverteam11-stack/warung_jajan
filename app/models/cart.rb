class Cart
  Item = Struct.new(:product, :quantity, keyword_init: true) do
    def subtotal_cents
      product.price_cents * quantity
    end
  end

  def initialize(session)
    @session = session
    session[:cart] ||= {}
  end

  def add(product_id, quantity = 1)
    product_id = product_id.to_s
    cart[product_id] = cart[product_id].to_i + quantity.to_i
  end

  def update_quantity(product_id, quantity)
    product_id = product_id.to_s
    if quantity.to_i <= 0
      remove(product_id)
    else
      cart[product_id] = quantity.to_i
    end
  end

  def remove(product_id)
    cart.delete(product_id.to_s)
  end

  def clear
    @session[:cart] = {}
  end

  def empty?
    cart.empty?
  end

  def items
    return [] if empty?

    products = Product.where(id: cart.keys).index_by { |product| product.id.to_s }
    cart.filter_map do |product_id, quantity|
      product = products[product_id]
      Item.new(product: product, quantity: quantity) if product
    end
  end

  def total_cents
    items.sum(&:subtotal_cents)
  end

  def to_h
    cart
  end

  private

  def cart
    @session[:cart]
  end
end
