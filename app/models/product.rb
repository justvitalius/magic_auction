class Product < ActiveRecord::Base
  has_many :images, :class_name => 'ProductImage', :dependent => :destroy
  has_many :auctions, dependent: :destroy
  belongs_to :category

  validates :title, presence: true, length: {maximum: 64}
  validates :description, allow_blank: true, length: {maximum: 1000}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0.01}

  accepts_nested_attributes_for :images, allow_destroy: true
end
