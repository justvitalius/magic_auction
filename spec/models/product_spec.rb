require 'spec_helper'

describe Product do
  it 'should validates presence of title'
  it 'should have title length less then 64 chars'
  it 'should have image'
  it 'should validates presence of price'
  it 'should validates price format'
  it 'should have price length less then 10 chars'
  it 'should have description'
  it 'should have description length less then 1000 chars'
end
