class Auction < ActiveRecord::Base
  belongs_to :product

  validates :title, presence: true, length: { maximum: 64 }
  validates :product_id, presence: true, numericality: { only_integer: true }
  validates :expire_date, presence: true, timeliness: { on_or_after: lambda{ DateTime.now }, on_or_before: lambda{ DateTime.now + 1.year }, allow_blank: false }

  def images
    product.images
  end
end
