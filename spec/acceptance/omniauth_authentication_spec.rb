require 'acceptance/acceptance_helper'


# This is an example of logging into a website using OmniAuth using
# the site's actual login links/buttons.
#
# If you're rigged your links/buttons to do magic, this may or may not work.
feature 'Using Login Buttons' do
  let(:path) { new_user_session_path }

  background do
    visit path
    #logged_in?.should == false
  end


  let!(:user) { create(:user) }
  scenario "using Facebook" do
    visit new_user_session_path
    OmniAuth.config.add_mock(:facebook, {uid: '12345', info: { email: 'test@mail.com', nickname: 'Nick' }})

    click_on 'через Facebook'

    expect(current_path).to eq(root_path)
    expect(page).to have_content 'Вход в систему выполнен с учётной записью из Facebook'
  end

  scenario "using Twitter" do
    OmniAuth.config.add_mock :twitter, uid: "twitter-12345", info: { name: "Bob Smith" }
    click_on "через Twitter"

    page.should have_content "Вы успешно вошли через соц.сеть"
    logged_in?.should == true
  end
  #
  scenario "using Vkontakte" do
    OmniAuth.config.add_mock :vkontakte, uid: "vk-12345", info: { name: "Bob Smith" }
    click_on "через Vkontakte"

    page.should have_content "Вы успешно вошли через соц.сеть"
    logged_in?.should == true
  end

  scenario "invalid login" do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    click_on "через Twitter"

    page.should have_content "Ошибка при входе через соц.сеть"
    logged_in?.should == false
  end

end