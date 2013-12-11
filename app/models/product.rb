class Product < ActiveRecord::Base
  validates :title, presence: true, length: {maximum: 64}
  validates :description, allow_blank: true, length: {maximum: 1000}
  validates_numericality_of :price, presence: true, less_than: 1000000, only_integer: true
end
