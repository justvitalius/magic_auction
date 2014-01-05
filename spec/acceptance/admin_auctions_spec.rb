require 'spec_helper'

feature "Admin manage auctions", %q{
  In order to manage auction's settings
  As an admin
  I want to view, create, edit and delete auctions.
 } do

  background  do
    @admin = create(:admin)
    visit new_user_session_path
    sign_in_with @admin.email, '12345678'
  end

  scenario 'should render auctions list' do
    visit admin_auctions_path
    expect(page).to have_content('аукционы')
  end

  context 'should edit exists auctions' do
    background do
      create(:auction)
    end

    scenario 'edit exists auction' do
      visit admin_auctions_path
      #save_and_open_page
      click_on 'редактировать'
      expect(page).to have_content('редактирование')
    end
  end

  context 'should create new auction' do
    background do
      @product = create(:product, title: 'product for auction')
    end

    scenario 'view new auction form' do
      visit new_admin_auction_path
      expect(page).to have_content('новый аукцион')
    end

    scenario 'create new valid auction' do
      visit new_admin_auction_path

      fill_in 'название', with: 'аукцион 1'
      select_datetime DateTime.now, from: 'дата окончания'
      select @product.title, from: 'товар'
      click_on 'сохранить'

      expect(current_path).ro eq(admin_auctions_path)
      expect(page).to have_content('аукционы')
    end

    scenario 'create new invalid auction' do
      visit new_admin_auction_path

      fill_in 'название', with: 'аукцион 1'
      select_datetime (DateTime.now - 1.month), from: 'дата окончания'
      click_on 'сохранить'

      expect(page).to have_content('новый аукцион')
    end
  end
end