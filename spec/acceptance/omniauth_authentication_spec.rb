require 'acceptance/acceptance_helper'

feature "User authenticate by social network", %q{
  In order to make a bet
  As an user
  I want to authenticate by social networks.
 } do

  let(:path) { new_user_session_path }

  background do
    visit path
    logged_in?.should == false
  end

  context 'for unregistered user' do

    scenario 'using Facebook' do
      OmniAuth.config.add_mock :facebook, uid: 'fb-12345', info: { email: 'test@mail.com', name: 'Bob Smith' }

      click_on 'через Facebook'

      expect(current_path).to eq(root_path)
      expect(page).to have_content 'Вы успешно вошли через соц.сеть'
      logged_in?.should == true
    end

    scenario 'using Twitter' do
      OmniAuth.config.add_mock :twitter, uid: 'tw-12345', info: { name: 'Bob Smith' }

      click_on 'через Twitter'


      expect(current_path).to eq(new_user_registration_path)
      fill_in 'email', with: 'oauth@mail.ru'
      fill_in 'пароль', with: '12345678'
      fill_in 'подтверждение пароля', with: '12345678'
      click_on 'зарегистрироваться'


      expect(current_path).to eq(root_path)
      page.should have_content 'Вы успешно зарегистрировались'
      logged_in?.should == true
    end
    #
    scenario 'using Vkontakte' do
      OmniAuth.config.add_mock :vkontakte, uid: 'vk-12345', info: { name: 'Bob Smith' }

      click_on 'через Vkontakte'

      expect(current_path).to eq(new_user_registration_path)
      fill_in 'email', with: 'oauth@mail.ru'
      fill_in 'пароль', with: '12345678'
      fill_in 'подтверждение пароля', with: '12345678'
      click_on 'зарегистрироваться'

      expect(current_path).to eq(root_path)
      page.should have_content 'Вы успешно зарегистрировались'
      logged_in?.should == true
    end
  end

  context 'for registered user' do
  end
end