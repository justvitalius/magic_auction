class Category < ActiveRecord::Base
  validates :title, presence: true, length: {maximum: 64}
end
