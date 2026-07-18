class Order < ApplicationRecord
  class InsufficientStock < StandardError; end

  PAYMENT_METHODS = %w[transfer cod].freeze
  STATUSES = %w[pending confirmed processing completed cancelled].freeze

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :customer_name, :customer_phone, :customer_address, presence: true
  validates :payment_method, inclusion: { in: PAYMENT_METHODS }
  validates :status, inclusion: { in: STATUSES }
  validates :number, presence: true, uniqueness: true
  validates :total_cents, numericality: { greater_than: 0 }
  validates :order_items, presence: true

  before_validation :generate_number, on: :create

  # cart is a { product_id => quantity } hash, as stored in the session.
  def self.checkout!(cart:, customer_name:, customer_phone:, customer_address:, payment_method:)
    transaction do
      order = new(
        customer_name: customer_name,
        customer_phone: customer_phone,
        customer_address: customer_address,
        payment_method: payment_method,
        total_cents: 0
      )

      total_cents = 0

      cart.each do |product_id, quantity|
        quantity = quantity.to_i
        product = Product.lock.find(product_id)
        raise InsufficientStock, "Stok #{product.name} tidak cukup" if product.stock < quantity

        product.update!(stock: product.stock - quantity)

        subtotal_cents = product.price_cents * quantity
        order.order_items.build(
          product: product,
          product_name: product.name,
          unit_price_cents: product.price_cents,
          quantity: quantity,
          subtotal_cents: subtotal_cents
        )
        total_cents += subtotal_cents
      end

      order.total_cents = total_cents
      order.save!
      order
    end
  end

  def to_param
    number
  end

  private

  def generate_number
    self.number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.alphanumeric(5).upcase}"
  end
end
