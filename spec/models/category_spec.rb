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
    end

    it '#image' do
      @category.image = @img_name
      except(@category.image).to eq(@img_name)
    end

    it '#image_url' do
      @category.image = @img_name
      except(@category.image_url).to eq("/system/categories/1/#{@img_name}")
    end

  end

  describe 'should have trees mode' do
    it 'should have #children'
    it 'should have #parent'
  end
end
