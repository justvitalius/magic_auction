require 'spec_helper'

feature "Admin authenticate", %q{
  In order to manage site essences
  As an admin
  I want to logging on admin area
 } do

  let(:path){ admin_root_path }
  let(:admin){ create(:admin) }

  it_behaves_like 'Admin_accessible'

  context 'Private office' do
    let(:path){ edit_user_registration_path }

    background do
      prepare_testing_area
    end

    scenario 'Authenticated admin visit private office' do
      expect(current_path).to eq(edit_user_registration_path)
      expect(page).to have_content('Личный кабинет')
    end

    scenario 'Authenticated admin update information in private office' do
      fill_in 'email', with: 'admin_new@mail.ru'
      fill_in 'текущий', with: '12345678'
      click_on 'сохранить'

      #save_and_open_page
      expect(current_path).to eq(edit_user_registration_path)
      expect(page).to have_content('запись изменена')
    end
  end


  # this test need roles
  scenario 'Non-admin user tries to log in' do
    #us = create(:user)
    #
    #sign_in_with us.email, '12345678'
    #
    #expect(page).to have_content('У вас нет прав доступа к этой странице')
  end


  context 'UI links' do
    context 'Non-authenticated user' do
      scenario 'visit login page' do
        visit root_path
        #save_and_open_page
        page.all('.nav a', text: 'войти').map(&:click)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('вход')
      end
    end

    context 'Authenticated user' do
      let(:path){ new_user_session_path }

      background do
        prepare_testing_area
      end

      scenario 'logout' do
        click_on 'выйти'

        expect(page).to have_content('Вы вышли')
      end

      scenario 'visit private office' do
        click_on admin.email

        expect(current_path).to eq(edit_user_registration_path)
      end
    end
  end
end