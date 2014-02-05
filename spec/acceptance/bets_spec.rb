require 'acceptance/acceptance_helper'

feature "Users make bets", %q{
  In order to buy a product
  As an user
  I want to make a bet
 } do

  describe 'tries to bet as unregistarable visitor' do
    pending
  end

  describe 'tries to bet as registarable user' do

    context 'active auctions' do

      describe 'should make a bet' do
        it 'should create a bet' do
          pending
        end

        it 'should update auctions expire-date' do
          pending
        end

        it 'should update auctions price' do
          pending
        end
      end

    end

    context 'future auctions' do
      describe 'should not give a bet' do
        pending
      end
    end

    context 'expired auctions' do
      describe 'should not give a bet' do
        pending
      end
    end

  end

end