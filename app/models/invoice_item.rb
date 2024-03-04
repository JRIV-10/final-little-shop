class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true
  
  enum status: {"Pending" => 0, "Packaged" => 1, "Shipped" => 2}

  def bulk_discount
    item.merchant.bulk_discounts
    .where('quantity <= ?', quantity)
    .order(discount: :desc)
    .first
  end
end
