require 'acceptance/acceptance_helper'

feature "All user view auctions list", %q{
  In order to bids auctions
  As an anyone
  I want to view current and ended auctions
} do

  describe 'auctions list on root path' do

    let!(:current_auctions) { 5.times.map { |i| create(:auction_with_images) } }
    let!(:ended_auctions) { 5.times.map { |i| create(:expired_auction) } }

    before do
      visit root_path
    end

    scenario 'should have current auctions' do
      expect(page).to have_content('Текущие аукционы')
      within '.spec-current-auctions' do
        current_auctions.each do |a|
          expect(page).to have_content(a.title)
        end

        ended_auctions.each do |a|
          expect(page).to_not have_content(a.title)
        end
      end
      expect(current_path).to eq(root_path)
    end

    scenario 'should have ended auctions' do
      expect(page).to have_content('Завершенные аукционы')

      within '.spec-ended-auctions' do
        current_auctions.each do |a|
          expect(page).to_not have_content(a.title)
        end

        ended_auctions.each do |a|
          expect(page).to have_content(a.title)
        end
      end
      expect(current_path).to eq(root_path)
    end

  end

end