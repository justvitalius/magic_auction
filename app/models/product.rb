class Product < ActiveRecord::Base
  validates :title, presence: true, length: {maximum: 64}
  validates :description, allow_blank: true, length: {maximum: 1000}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0.01}
end
