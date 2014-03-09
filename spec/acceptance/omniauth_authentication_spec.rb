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

  describe 'login' do
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
  end

  describe 'bind social networks in profile' do
    let!(:user) { create(:user) }
    let(:path) { profile_path }

    background do
      sign_in_with user.email, '12345678'
      expect(page).to have_content 'привязать facebook'
    end

    context 'bind with other user' do
      let(:auth) { OmniAuth.config.add_mock :facebook, uid: 'fb-12345', info: { email: 'other@mail.ru', name: 'Bob Smith' } }
      let(:other_user) { create(:user, email: 'other@mail.ru') }
      background do
        other_user.add_authorization auth
        click_on 'привязать facebook'
      end

      scenario 'bind facebook' do
        expect(page).to have_content 'Соц.сеть уже привязана к другим аккаунтам'
      end
    end

    context 'bind with current user' do
      background do
        OmniAuth.config.add_mock :facebook, uid: 'fb-12345', info: { email: user.email, name: 'Bob Smith' }
        click_on 'привязать facebook'
      end

      scenario 'bind facebook' do
        expect(page).to have_content 'Соц.сеть успешно добавлена'
      end
    end
  end
end