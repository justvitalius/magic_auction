require 'spec_helper'

describe Category do
  describe 'should validates title' do
    it { should validate_presence_of(:title) }
    it { should ensure_length_of(:title).is_at_most(64) }
  end

  describe 'should have image' do
    before(:all) do
      @category = Category.new(title: 'cat1')
      @img_name = 'img.png'
      @uploader = ImageUploader.new(@category, :image)
    end

    it '#image' do
      @category.image = @img_name
      expect(@category.image).to be_kind_of(ImageUploader)
    end
  end

  describe 'should have trees mode' do
    before(:all) do
      @cat1 = Category.new(title: 'cat1')
    end

    it 'should have #children' do
      @cat2 = Category.new(title: 'cat2', children: @cat1 )
      expect(@cat2.children).to eq(@cat1)
    end

    it 'should have #parent' do
      @cat2 = Category.new(title: 'cat2', parent: @cat1 )
      expect(@cat2.parent).to eq(@cat1)
    end
  end
end
