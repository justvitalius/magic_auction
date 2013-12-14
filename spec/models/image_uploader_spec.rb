require 'spec_helper'
require 'carrierwave/test/matchers'
require 'carrierwave/processing/mini_magick'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  context 'exists image uploading' do
    before do
      @path_to_file = "#{Rails.root}/public/gem.jpg"
      @category = Category.new
      ImageUploader.enable_processing = true
      @uploader = ImageUploader.new(@category, :image)
      @uploader.store!(File.open(@path_to_file))
    end

    after do
      ImageUploader.enable_processing = false
      @uploader.remove!
    end

    it 'should scale down to "xs" version' do
      @uploader.xs.should have_dimensions(50, 50)
    end

    it 'should scale down to "s" version' do
      @uploader.s.should be_no_larger_than(200, 200)
    end

    it 'should scale down to "m" version' do
      @uploader.m.should be_no_larger_than(500, 500)
    end
  end

  context 'without image uploading' do
    before do
      @path_to_file = "#{Rails.root}/public/gem.jpg"
      @category = Category.new
      @uploader = ImageUploader.new(@category, :image)
    end

    it 'should return default not scaled image' do
      expect(@uploader.url).to eq('/fallback/default.png')
    end

    context 'the scaled version' do
      it 'should return "m" image size' do
        expect(@uploader.m.url).to eq('/fallback/m_default.png')
      end
    end
  end

end