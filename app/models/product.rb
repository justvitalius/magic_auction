class Product < ActiveRecord::Base
  validates :title, presence: true, length: {maximum: 64}
  validates :description, allow_blank: true, length: {maximum: 1000}
  validates_numericality_of :price, presence: true, only_integer: true
  validates_length_of :price, in: 1..10
end
