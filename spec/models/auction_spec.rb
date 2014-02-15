require 'spec_helper'

# TODO: как вообще эти тесты
describe Auction do

  let(:auction){ create(:auction) }

  describe '#title' do
    it {should validate_presence_of(:title)}
    it {should ensure_length_of(:title).is_at_most(64)}
  end

  describe '#time_step' do
    it{ validate_numericality_of(:time_step) }

    it 'should be equal to 30 by default' do
      expect(Auction.new.time_step).to eq(30)
    end

    it 'should be valid only equals 30 or 60 or 120 seconds' do
      [30, 60, 120].each do |time|
        auction.time_step = time
        expect(auction).to be_valid
      end
    end

    it 'not should be valid if not equals to 30, 60 or 120 seconds' do
      [28, 123, 1, 0, 121, 10313].each do |time|
        auction.time_step = time
        expect(auction).to_not be_valid
      end
    end
  end

  describe '#price_step' do
    it { should validate_presence_of(:price_step) }
    it { should validate_numericality_of(:price_step).is_greater_than_or_equal_to BigDecimal.new('0.01') }
  end

  describe '#price' do
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to BigDecimal.new('0.00') }
  end

  describe 'should have Product' do
    it { should belong_to(:product) }
    it { should accept_nested_attributes_for(:product) }

    describe 'should extra validate Product' do
      before do
        @auction = Auction.new(title: 'hello', expire_date: DateTime.now + 1.month, start_date: DateTime.now + 1.seconds, price_step: 1.00)
      end

      # можно заменить на одну строку от should_matchers
      it 'should be valid with parent_id' do
        @auction.product_id = 1
        expect(@auction).to be_valid
      end

      it 'should not be valid with empty product_id' do
        @auction.product_id = nil
        expect(@auction).to_not be_valid
      end

      # следующие два не надо
      it 'should be valid with product' do
        # лучше product чем pr
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
    # излишняя проверка, нижняя строка проверяет тоже самое
    #it { should respond_to(:category) }
    it 'should return product category' do
      expect(auction.category).to eq(auction.product.category)
    end
  end

  describe 'should have start and expire dates' do
    describe '#expire_date' do
      it {should validate_presence_of(:expire_date)}

      it 'should have expire date until now' do
        auction.expire_date = DateTime.now
        expect(auction).not_to be_valid
      end


      it 'should have expire date until today' do
        auction.expire_date = DateTime.now - 1.day
        expect(auction).not_to be_valid
      end

      describe 'should have expire date not later then 1 year later' do
        it 'expire date more than 1 year from now' do
          auction.expire_date = DateTime.now + 1.year + 1.second
          expect(auction).not_to be_valid
        end

        it 'expire date equal to 1 year from now' do
          auction.expire_date = DateTime.now + 1.year
          expect(auction).to be_valid
        end
      end

      it 'should be later than start_date' do
        auction.start_date = auction.expire_date + 1.second
        expect(auction).not_to be_valid
      end
    end

    describe '#start-date' do
      it {should validate_presence_of(:start_date)}

      it 'should not be earlier than now' do
        auction.start_date = DateTime.now - 2.minutes - 1.seconds
        expect(auction).not_to be_valid
      end


      it 'should be later than now' do
        auction.start_date = DateTime.now + 1.seconds
        expect(auction).to be_valid
      end

      it 'should be later than today' do
        auction.start_date = DateTime.now + 1.days
        expect(auction).to be_valid
      end

      describe 'should be earlier than expire-date' do
        it 'should be valid if earlier expire-date than 12 hours' do
          auction.start_date = auction.expire_date - 1.days
          expect(auction).to be_valid
        end

        it 'should be not valid if equal expire-date' do
          auction.start_date = auction.expire_date
          expect(auction).not_to be_valid
        end

        it 'should be not valid if later expire-date' do
          auction.start_date = auction.expire_date + 1.days
          expect(auction).not_to be_valid
        end
      end
    end
  end

  describe 'auctions scopes by actual dates' do
    let!(:current_auctions){ 5.times.map{ |i| create(:auction, title: "current-auction-#{i}") } }
    let!(:ended_auctions){ 5.times.map{ create(:expires_auction) } }
    let!(:futured_auctions){
      5.times.map{ |i| create(:auction, title: "tomorrow-auction-#{i}", start_date: DateTime.now+(i+1).day) }
    }


    it '#active' do
      expect(Auction.active).to eq(current_auctions)
    end

    it '#inactive' do
      expect(Auction.inactive).to eq(ended_auctions)
    end

    it '#futured' do
      expect(Auction.futured).to eq(futured_auctions)
    end

  end

  describe '#increase_finish_date' do
    context 'validations' do
      it 'should increase if finished-date before the expires-date' do
        pending
      end

      it 'should not increase if finished-date later expires-date' do
        pending
      end
    end
    context 'do it' do
      it 'should increase finish-date' do
        expect{ auction.increase_finish_date }.to change(auction, :finish_date).by(auction.time_step.seconds)
      end

      it 'should save self' do
        before_finish_date = auction.finish_date
        auction.increase_finish_date
        auction.reload
        expect(auction.finish_date).to eq(before_finish_date + auction.time_step)
      end
    end
  end

  describe '#increase_price' do
    it 'should increase price' do
      expect{ auction.increase_price }.to change(auction, :price).by(auction.price_step)
    end

    it 'should save self' do
      expect(auction.price).to eq(0)
      auction.increase_price
      auction.reload
      expect(auction.price).to eq(auction.price_step)
    end
  end

  describe '#active?' do
    it 'is active' do
      expect(auction.active?).to be_true
    end

    context 'is not active' do
      it 'is not active if now later expire-date' do
        allow(auction).to receive(:expire_date).and_return(DateTime.now - 1.second)
        expect(auction.active?).to be_false
      end

      it 'is not active if now later finish-date' do
        allow(auction).to receive(:finish_date).and_return(DateTime.now - 1.second)
        expect(auction.active?).to be_false
      end

      it 'is not active if now before the start-date' do
        allow(auction).to receive(:start_date).and_return(DateTime.now + 1.second)
        expect(auction.active?).to be_false
      end
    end
  end

end
