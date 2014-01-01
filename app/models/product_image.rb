class ProductImage < ActiveRecord::Base

  belongs_to :product

  validates :product_id, :image, presence: true

  mount_uploader :image, ProductImageUploader
end
