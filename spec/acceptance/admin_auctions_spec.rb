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

      expect(page.all('создать новый товар')).to be_empty
      expect(page).to have_content('новый аукцион')
    end

    scenario 'create new valid auction' do
      visit new_admin_auction_path

      fill_in 'название', with: 'аукцион 1'
      select_datetime DateTime.now, from: 'дата окончания'
      select @product.title, from: 'товар'

      expect{ click_on 'сохранить' }.to change(Auction, :count).by(1)
      expect(current_path).to eq(admin_auctions_path)
      expect(page).to have_content('аукционы')
    end

    scenario 'create new invalid auction' do
      visit new_admin_auction_path

      fill_in 'название', with: 'аукцион 1'
      select_datetime (DateTime.now - 1.month), from: 'дата окончания'
      click_on 'сохранить'

      expect(page).to have_content('новый аукцион')
    end

    # not working without js
    scenario 'create new valid auction and product together', js: true do
      category = create(:category)

      visit new_admin_auction_path
      # fill auction fields
      fill_in 'название', with: 'аукцион 1'
      select_datetime (DateTime.now + 1.month), from: 'дата окончания'
      # fill product fields
      click_on 'создать новый продукт'
      #save_screenshot('test_images/phantom.png', :full => true)
      within('.spec-product-fields') do
        fill_in 'название', with: 'product from auction'
        fill_in 'цена', with: '0.01'
        #choose  category.id
        all("input[type=radio][value='#{category.id}']").map(&:click)
      end
      expect{ click_on 'сохранить' }.to change(Product, :count).by(1)
      expect(current_path).to eq(admin_auctions_path)
    end
  end
end