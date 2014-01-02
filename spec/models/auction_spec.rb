require 'spec_helper'

describe Auction do
  describe 'should have title' do
    it {should validate_presence_of(:title)}
    it {should ensure_length_of(:title).is_at_most(64)}
  end

  describe 'should have Product' do
    it {should belong_to(:product)}
    it (should validate_presence_of(:product))
  end

  it '#images' do
    
  end
  it 'should validates presence of image'

  it 'should validates presence of expire date'
  it 'should have expire date until today'
  it 'should have expire date not later then 1 year later'

end
