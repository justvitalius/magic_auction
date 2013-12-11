require 'spec_helper'

describe Auction do
  it 'should validates presence of title'
  it 'should have title length less then 64 chars'

  it 'should have one Product'
  it 'should validates presence of Product'
  it 'should destroy if Product was destroyed'

  it 'should validates presence of image'

  it 'should validates presence of expire date'
  it 'should have expire date until today'
  it 'should have expire date not later then 1 year later'

end
