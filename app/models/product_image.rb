class ProductImage < ActiveRecord::Base

  belongs_to :product

  # with validates don't working nested form
  #validates :product_id, :image, presence: true

  mount_uploader :image, ProductImageUploader
end
