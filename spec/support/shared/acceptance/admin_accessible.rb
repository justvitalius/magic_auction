shared_examples_for 'Admin_accessible' do
  background do
    visit path
  end

  scenario 'Admin tries to get an access' do
    sign_in_with admin.email, '12345678'
    expect(page).to_not have_content('необходимо войти')
    expect(current_path).to_not eq(new_user_session_path)
  end

  scenario 'Non-admin user tries to log in' do
    us = create(:user)
    sign_in_with us.email, '12345678'
    expect(page).to have_content('У вас нет прав доступа к этой странице')
    expect(current_path).to eq(root_path)
  end

end