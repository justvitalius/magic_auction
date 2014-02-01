class ProductImage < ActiveRecord::Base

  belongs_to :product

  # with validates don't working nested form
  # validates :product_id, :image, presence: true
  # TODO: нужно ли здесь делать валидацию на наличие product?
  # лучше написать

  mount_uploader :image, ProductImageUploader
end
