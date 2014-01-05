require 'spec_helper'

feature "Admin authenticate", %q{
  In order to manage site essences
  As an admin
  I want to logging on admin area
 } do

  background do
    visit auctions_path
  end

  context 'Admin' do
    background do
      @admin = create(:admin)
    end

    scenario 'Unauthenticated user tries to get an access to admin area by direct link' do
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('необходимо войти')
    end

    scenario 'Admin successfully logging into admin area' do
      sign_in_with @admin.email, '12345678'

      expect(current_path).to eq(auctions_path)
    end

    scenario 'Admin fill in wrong parameters' do
      sign_in_with 'wrong', 'wrong'

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('неверное')
    end
  end

  context 'Private office' do
    background do
      @admin = create(:admin)
      visit new_user_session_path
      sign_in_with @admin.email, '12345678'
      visit edit_user_registration_path
    end

    scenario 'Authenticated admin visit private office' do
      expect(current_path).to eq(edit_user_registration_path)
      expect(page).to have_content('личный кабинет')
    end

    scenario 'Authenticated admin update information in private office' do
      fill_in 'email', with: 'admin_new@mail.ru'
      click_on 'сохранить'

      expect(current_path).to eq(edit_user_registration_path)
      expect(page).to have_content('данные обновлены')
    end
  end


  # this test need roles
  scenario 'Non-admin user tries to log in' do
    us = create(:user)

    sign_in_with us.email, '12345678'

    expect(page).to have_content('У вас нет прав доступа к этой странице')
  end


  context 'UI links' do
    context 'Non-authenticated user' do
      scenario 'visit login page' do
        visit root_path
        first('.nav').click_link('войти')

        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('вход')
      end
    end

    context 'Authenticated user' do
      background do
        @user = create(:admin)
        visit new_user_session_path
        sign_in_with @user.email, '12345678'
      end

      scenario 'logout' do
        click_on 'выйти'

        expect(current_path).to eq(root_path)
        expect(page).to have_content('вы вышли')
      end

      scenario 'visit private office' do
        click_on @user.email

        expect(current_path).to eq(edit_user_registration_path)
        expect(page).to have_content('личный кабинет')
      end
    end
  end
end