module Features
  module SessionsHelpers
    def sign_in_with(email, password)
      fill_in 'email', with: email
      fill_in 'пароль', with: password
      click_on "войти"
    end
  end
end