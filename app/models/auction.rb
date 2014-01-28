class Auction < ActiveRecord::Base
  belongs_to :product, inverse_of: :auctions

  validates :title, presence: true, length: { maximum: 64 }

  # TODO: так валидация на обязательное наличие product нормальна?
  validates :product_id, presence: true, numericality: { only_integer: true }, unless: lambda{ |a| a.product.try(:valid?) }
  validates :product, presence: true, if: lambda{ |a| a.product.try(:valid?) }

  # TODO: эту валидацию можно оформить по другому?
  validates :expire_date, presence: true, timeliness: { on_or_after: lambda{ DateTime.now }, on_or_before: lambda{ DateTime.now + 1.year }, allow_blank: false }


  # TODO: как сделать правильно статусы аукционы? Через state-machine? Они вообще нужны?

  accepts_nested_attributes_for :product

  scope :active, -> { where('expire_date > ?', Time.now) }
  scope :inactive, -> { where('expire_date <= ?', Time.now) }

  def images
    product.images || []
  end

  def category
    product.category || nil
  end
end
