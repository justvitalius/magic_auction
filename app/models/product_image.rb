class ProductImage < ActiveRecord::Base

  belongs_to :product

  validate :product_id, presence: true
  validate :image, presence: true

  mount_uploader :image, ProductImageUploader
end
