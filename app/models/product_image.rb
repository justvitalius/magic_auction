class ProductImage < ActiveRecord::Base
  mount_uploader :image, ProductImageUploader
end
