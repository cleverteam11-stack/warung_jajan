class Product < ApplicationRecord
  STATUSES = %w[active discontinued].freeze

  belongs_to :category, optional: true
  has_many :order_items, dependent: :restrict_with_error
  has_one_attached :photo

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :price_cents, numericality: { greater_than: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }

  before_validation :generate_slug, on: :create

  scope :active, -> { where(status: "active") }

  def available?
    status == "active" && stock.positive?
  end

  private

  def generate_slug
    self.slug = name.to_s.parameterize if slug.blank? && name.present?
  end
end
