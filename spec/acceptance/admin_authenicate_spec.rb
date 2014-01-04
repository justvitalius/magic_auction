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

    scenario 'Unauthenticated user tries to get an access to admin area' do
      expect(current_path).to eq(new_user_sessions_path)
      expect(page).to have_content('необходимо войти')
    end

    scenario 'Admin successfully logging into admin area' do
      sign_in_with @admin.email, '12345678'

      expect(current_path).to eq(auctions_path)
    end

    scenario 'Admin fill in wrong parameters' do
      sign_in_with 'wrong', 'wrong'

      expect(current_path).to eq(new_user_sessions_path)
      expect(page).to have_content('неверное')
    end
  end

  context 'Private office' do
    background do
      @admin = create(:admin)
      visit edit_registration_path
    end

    scenario 'Admin visit private office' do
      expect(current_path).to eq(edit_registration_path)
      expect(page).to have_content('личный кабинет')
    end

    scenario 'Admin update information in private office' do
      fill_in 'email', with: 'admin_new@mail.ru'
      click_on 'сохранить'

      expect(current_path).to eq(edit_registration_path)
      expect(page).to have_content('данные обновлены')
    end
  end


  scenario 'Non-admin user tries to log in' do
    us = create(:user)

    sign_in_with us.email, '12345678'

    expect(page).to have_content('У вас нет прав доступа к этой странице')
  end
end