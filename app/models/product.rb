class Product < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :nullify

  validates :name, :brand, :sku, presence: true
  validates :sku, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
  validates :old_price, numericality: { greater_than: :price }, allow_nil: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :featured, -> { where(featured: true) }
  scope :in_stock, -> { where("stock > 0") }

  # Пошук за назвою, брендом, артикулом або сумісністю з авто
  scope :search, ->(q) {
    next all if q.blank?
    term = "%#{sanitize_sql_like(q.downcase)}%"
    where("LOWER(products.name) LIKE :t OR LOWER(brand) LIKE :t OR LOWER(sku) LIKE :t OR LOWER(compatibility) LIKE :t", t: term)
  }

  SORTS = {
    "new"        => { created_at: :desc },
    "price_asc"  => { price: :asc },
    "price_desc" => { price: :desc },
    "name"       => { name: :asc }
  }.freeze

  scope :sorted, ->(key) { order(SORTS.fetch(key.to_s, SORTS["new"])) }

  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end

  def in_stock?
    stock.positive?
  end

  def discount_percent
    return 0 unless old_price
    ((1 - price / old_price) * 100).round
  end
end
