require 'acceptance/acceptance_helper'

feature "Users make bets", %q{
  In order to buy a product
  As an user
  I want to make a bet
 } do

  let(:auction){ create(:auction_with_images )}
  let(:path){ auction_path(auction) }

  describe 'tries to make a bet as unregistarable visitor' do
    it 'should not make a bet' do
      visit path

      expect{click_on('сделать ставку')}.to_not change(Bet, :count)
      expect(page).to have_content('зарегистрируйтесь')
      expect(current_path).to eq(path)
    end
  end

  describe 'tries to bet as registarable user' do
    let(:user){ create(:user) }

    context 'active auctions' do
      before do
        visit new_user_session_path
        sign_in_with user.email, '12345678'
        visit path
      end

      describe 'should make a bet' do
        it 'should create a bet' do
          expect{ click_on 'сделать ставку' }.to change(Bet, :count)
          expect(page).to have_content('ставка сделана')
        end

        it 'should update auctions finish-date' do
          old_finish_date = find('.spec-auction-finish-date').text

          click_on 'сделать ставку'

          expect(page).to have_content('время окончания аукциона')
          expect(page.find('.spec-auction-finish-date').text).to_not eq(old_finish_date)
        end

        it 'should update auctions price' do
          old_price = find('.spec-auction-price').text

          click_on 'сделать ставку'

          expect(page).to have_content('текущая стоимость лота')
          expect(page.find('.spec-auction-price').text).to_not eq(old_price)
        end
      end

    end

    context 'future auctions' do

      describe 'should not give a bet' do
        it 'should not have a "make a bet" button' do
          visit path

          expect(page).to_not have_content('сделать ставку')
        end
      end
    end

    context 'expired auctions' do
      describe 'should not give a bet' do
        it 'should not have "make a bet" button' do
          visit path

          expect(page).to_not have_content('сделать ставку')
        end
      end
    end

  end

end