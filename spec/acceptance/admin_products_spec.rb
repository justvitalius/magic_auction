require 'spec_helper'

feature "Admin manage products", %q{
  In order to manage auction's settings
  As an admin
  I want to manage products.
 } do

  background  do
    @admin = create(:admin)
    visit new_user_session_path
    sign_in_with @admin.email, '12345678'
  end

  scenario 'should render products list' do
    visit admin_products_path
    expect(page).to have_content('товары')
  end

  context 'should edit exists products' do
    background do
      create(:product)
    end

    scenario 'edit exists product' do
      visit admin_products_path
      #save_and_open_page
      click_on 'редактировать'
      expect(page).to have_content('редактирование')
    end
  end

  context 'should create new product' do
    scenario 'view new auction form' do
      visit new_admin_product_path
      expect(page).to have_content('новый аукцион')
    end
  end
end