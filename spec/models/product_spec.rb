require 'spec_helper'

describe Product do

  it {should validate_presence_of(:title)}
  it {should ensure_length_of(:title).is_at_most(64)}


  it 'should have image'

  it {should validate_presence_of(:price)}
  it {should validate_numericality_of(:price).is_less_than(1000000).only_integer}
  it 'should validate price integer parts and cents'

  it {should ensure_length_of(:description).is_at_most(1000)}

  it 'should have many Auctions'
end
