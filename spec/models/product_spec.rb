require 'spec_helper'
require 'bigdecimal'

describe Product do

  describe 'it should have title' do
    it {should respond_to(:title)}
    it {should validate_presence_of(:title)}
    it {should ensure_length_of(:title).is_at_most(64)}
  end


  describe 'should have images' do
    before do
      @pr = Product.new(title: 'pr1', description: 'pr1 description', price: 1.00)
    end

    it {should respond_to(:images)}
    it 'should have empty images by default' do
      expect(@pr.images).to eq([])
    end

    it 'should have several images' do
      @pr.images << ImageUploader.new(@pr, :product_image)
      @pr.images << ImageUploader.new(@pr, :product_image)
      expect(@pr.images.length).to eq(2)
    end
  end

  describe 'it should have price' do
    it {should respond_to(:price)}
    it {should validate_presence_of(:price)}
    it {should validate_numericality_of(:price).is_greater_than_or_equal_to BigDecimal.new('0.01')}
  end

  describe 'it should have description' do
    it {should respond_to(:description)}
    it {should ensure_length_of(:description).is_at_most(1000)}
  end

  it 'should have many Auctions'
end
