require 'spec_helper'

describe Auction do
  before do
    @auction = create(:auction)
  end

  describe 'should have title' do
    it {should validate_presence_of(:title)}
    it {should ensure_length_of(:title).is_at_most(64)}
  end

  describe 'should have Product' do
    it {should belong_to(:product)}
    it {should validate_presence_of(:product_id)}
  end

  describe '#images' do
    before do
      pr = create(:product_with_images)
      @auction = create(:auction, product: pr)
    end

    it 'should have equals images count' do
      expect(@auction.images.count).to eq(@auction.product.images.count)
    end

    it 'should have equals first images' do
      expect(@auction.images.first).to eq(@auction.product.images.first)
    end
  end

  describe 'should have expire date' do
    it {should validate_presence_of(:expire_date)}

    it 'should have expire date until now' do
      @auction.expire_date = DateTime.now
      expect(@auction).not_to be_valid
    end


    it 'should have expire date until today' do
      @auction.expire_date = DateTime.now - 5.month
      expect(@auction).not_to be_valid
    end

    describe 'should have expire date not later then 1 year later' do
      it 'expire date more than 1 year from now' do
        @auction.expire_date = DateTime.now + 1.year + 1.day
        expect(@auction).not_to be_valid
      end

      it 'expire date equal to 1 year from now' do
        @auction.expire_date = DateTime.now + 1.year
        expect(@auction).to be_valid
      end
    end
  end

end
