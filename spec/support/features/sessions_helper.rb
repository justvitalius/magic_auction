module Features
  module SessionsHelper
    def sign_in_with(email, password)
      within 'form' do
        fill_in 'email', with: email
        fill_in 'пароль', with: password
        #click_on "войти"
        click_on 'войти'
      end
      #find('form').click('войти')
    end

    def prepare_testing_area
      visit path
      sign_in_with admin.email, 12345678
    end
  end
end