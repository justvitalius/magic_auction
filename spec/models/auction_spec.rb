require 'spec_helper'

describe Auction do

  let(:auction){ create(:auction) }

  describe 'should have title' do
    it {should validate_presence_of(:title)}
    it {should ensure_length_of(:title).is_at_most(64)}
  end

  describe 'should have Product' do
    it { should belong_to(:product) }
    it { should accept_nested_attributes_for(:product) }

    describe 'should extra validate Product' do
      before do
        @auction = Auction.new(title: 'hello', expire_date: DateTime.now + 1.month)
      end

      it 'only parent_id' do
        @auction.product_id = 1
        expect(@auction).to be_valid
      end

      it 'empty product_id' do
        @auction.product_id = nil
        expect(@auction).to_not be_valid
      end

      it 'only product' do
        pr = create(:product)
        @auction.product = pr
        expect(@auction).to be_valid
      end

      it 'empty product' do
        @auction.product = nil
        expect(@auction).to_not be_valid
      end
    end

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

  describe '#category' do
    it { should respond_to(:category) }
    it 'should return product category' do
      expect(auction.category).to eq(auction.product.category)
    end
  end

  describe 'should have expire date' do
    it {should validate_presence_of(:expire_date)}

    it 'should have expire date until now' do
      auction.expire_date = DateTime.now
      expect(auction).not_to be_valid
    end


    it 'should have expire date until today' do
      auction.expire_date = DateTime.now - 5.month
      expect(auction).not_to be_valid
    end

    describe 'should have expire date not later then 1 year later' do
      it 'expire date more than 1 year from now' do
        auction.expire_date = DateTime.now + 1.year + 1.day
        expect(auction).not_to be_valid
      end

      it 'expire date equal to 1 year from now' do
        auction.expire_date = DateTime.now + 1.year
        expect(auction).to be_valid
      end
    end
  end

  describe 'auctions scopes by expire-date' do
    let!(:current_auctions){ 5.times.map{ |i| create(:auction, title: "current-auction-#{i}") } }
    let!(:ended_auctions) do
      5.times.map do |i|
        a = create(:auction, title: "ended-auction-#{i}")
        a.update_attribute(:expire_date, DateTime.yesterday)
        a
      end
    end

    it '#active' do
      as = Auction.active
      expect(as - current_auctions).to eq([])
    end

    it '#inactive' do
      as = Auction.inactive
      expect(as - ended_auctions).to eq([])
    end
  end


end
