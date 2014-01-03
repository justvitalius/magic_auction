class Category < ActiveRecord::Base
  validates :title, presence: true, length: {maximum: 64}

  has_many :products, dependent: :nullify

  mount_uploader :image, ImageUploader
  has_ancestry
end
