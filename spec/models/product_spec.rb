require 'spec_helper'
require 'bigdecimal'

describe Product do

  describe 'it should have title' do
    it { should respond_to(:title) }
    it { should validate_presence_of(:title) }
    it { should ensure_length_of(:title).is_at_most(64) }
  end


  describe 'should have images' do
    before do
      @pr = create(:product)
    end

    it { should have_many(:images).class_name('ProductImage').dependent(:destroy) }

    it 'should have empty images by default' do
      #expect(@pr.images).to eq([])
      expect(@pr.images).to be_empty
    end

    it 'should have several images' do
      @pr = create(:product_with_images, images_count: 2)
      expect(@pr.images.length).to eq(2)
    end
  end

  describe 'should have price' do
    it { should respond_to(:price) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to BigDecimal.new('0.01') }
  end

  describe 'should have description' do
    it { should respond_to(:description) }
    it { should ensure_length_of(:description).is_at_most(1000) }
  end

  describe 'should have category' do
    it { should belong_to(:category) }
    it { should validate_presence_of(:category_id) }

    it 'should clean category when removed category' do
      cat = create(:category)
      pr = create(:product, title: 'remove cat', category: cat)
      cat.destroy
      pr = Product.where(title: 'remove cat').first!
      expect(pr.category_id).to be_nil
    end
  end
  it { should have_many(:auctions).dependent(:destroy) }
end
