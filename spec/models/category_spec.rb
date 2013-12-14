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
      @cat2 = Category.create!(title: 'cat2')
      @cat1 = Category.create!(title: 'cat1', parent: @cat2)
    end

    it 'should have #children' do
      expect(@cat2.children.exists?(@cat1)).to eq(true)
    end

    it 'should have #parent' do
      expect(@cat1.parent).to eq(@cat2)
    end
  end
end
