require 'spec_helper'
require 'carrierwave/test/matchers'
require 'carrierwave/processing/mini_magick'

describe ProductImage do
  include CarrierWave::Test::Matchers

  describe 'should have ProductImage' do
    it {validate_presence_of(:image)}
    describe 'should return uploaded image' do
      before do
        @path_to_file = "#{Rails.root}/public/gem.jpg"
        @pr_img = ProductImage.new
        ProductImageUploader.enable_processing = true
        @uploader = ProductImageUploader.new(@pr_img, :image)
        @uploader.store!(File.open(@path_to_file))
      end

      after do
        ProductImageUploader.enable_processing = false
        @uploader.remove!
      end

      context 'scaled images' do
        it 'should scale down to "xs" version' do
          @uploader.xs.should have_dimensions(64, 64)
        end

        it 'should scale down to "s" version' do
          @uploader.s.should be_no_larger_than(192, 192)
        end

        it 'should scale down to "m" version' do
          @uploader.m.should be_no_larger_than(512, 512)
        end
      end
    end

    describe 'should return default image' do
      before do
        @pr_img = ProductImage.new
        @uploader = ProductImageUploader.new(@pr_img, :image)
      end

      it 'should return default not scaled image' do
        expect(@uploader.url).to eq('/assets/fallback/product_images/default.png')
      end

      context 'the scaled version' do
        it 'should return "m" image size' do
          expect(@uploader.m.url).to eq('/assets/fallback/product_images/m_default.png')
        end
      end
    end

    describe 'should have exists default image' do
      before do
        @mod = ''
        @path_to_file = "#{Rails.root}/app/assets/images/fallback/product_images/#{@mod}default.png"
      end

      it 'exists "m" size' do
        @mod = 'm_'
        expect(File.exists?(@path_to_file)).to eq(true)
      end

      it 'exists "s" size' do
        @mod = 's_'
        expect(File.exists?(@path_to_file)).to eq(true)
      end

      it 'exists "xs" size' do
        @mod = 'xs_'
        expect(File.exists?(@path_to_file)).to eq(true)
      end

      it 'exists "default" size' do
        @mod = ''
        expect(File.exists?(@path_to_file)).to eq(true)
      end
    end
  end

  describe 'should have Product' do
    it {should belong_to(:product)}
    it {should validate_presence_of(:product_id)}
  end

end
