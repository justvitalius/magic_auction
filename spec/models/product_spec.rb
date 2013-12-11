require 'spec_helper'

describe Product do

  it {should respond_to(:title)}
  it {should validate_presence_of(:title)}
  it {should ensure_length_of(:title).is_at_most(64)}


  it 'should have image'

  it {should respond_to(:price)}
  it {should validate_presence_of(:price)}
  it {should validate_numericality_of(:price).only_integer}
  it {should validate_numericality_of(:price).is_less_than_or_equal_to(1000000)}
  it {should validate_numericality_of(:price).is_greater_than_or_equal_to(1)}
  it 'should validate price integer parts and cents'

  it {should respond_to(:description)}
  it {should ensure_length_of(:description).is_at_most(1000)}

  it 'should have many Auctions'
end
