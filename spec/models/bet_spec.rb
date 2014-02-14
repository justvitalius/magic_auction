require 'spec_helper'
require 'bigdecimal'

describe Bet do

  let(:bet){ create(:bet) }

  describe 'should have relations to user' do
    it { should belong_to(:user).dependent(:destroy) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'should have relations to auction' do
    it { should belong_to(:auction).dependent(:destroy) }
    it { should validate_presence_of(:auction_id) }
  end

  describe '#type' do
    it{ should validate_presence_of(:type) }
    it{ should validate_numericality_of(:type) }

    it 'should be equal to "1" by default' do
      expect(Bet.new.type).to eq(1)
    end

    it 'should be valid only equals "1" or "2"' do
      [1, 2].each do |type|
        bet.type = type
        expect(bet).to be_valid
      end
    end

    it 'not should be valid if not equals to 1, 2' do
      ([0]+[3..rand(100)]).each do |type|
        bet.type = type
        expect(bet).to_not be_valid
      end
    end
  end

  context 'when created' do
    let(:auction){ create(:auction) }
    let(:bet){ create(:bet, auction: lot) }

    before do
      allow(auction).to receive(:active?).and_return(true)
    end

    it 'increase auction price' do
      allow(auction).to receive(:increase_finish_time)
      expect(auction).to receive(:increase_price)
      bet.save!
    end

    it 'increase auction finish-time' do
      allow(auction).to recieve(:increase_price)
      expect(auction).to recieve(:increase_finish_time)
      bet.save!
    end
  end

  context 'validations' do
    it 'should be valid for active auction' do
      allow(auction).to recieve(:active?).and_return(true)
      expect(bet).to be_valid
    end

    it 'should be not valid for inactive auction' do
      allow(auction).to recieve(:active?).and_return(false)
      expect(bet).to_not be_valid
    end
  end

end
