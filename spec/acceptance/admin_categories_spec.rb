require 'spec_helper'

feature "Admin manage categories", %q{
  In order to manage auction's settings
  As an admin
  I want to manage categories.
 } do

  let(:admin){ create(:admin) }
  let(:path){ new_user_session_path }

  background  do
    prepare_testing_area
  end

  scenario 'should render categories' do
    visit admin_categories_path
    expect(page).to have_content('категории')
  end

  context 'should edit exists categories' do
    background do
      create(:category)
    end

    scenario 'edit exists category' do
      visit admin_categories_path
      #save_and_open_page
      first('a', text: 'редактировать').click
      expect(page).to have_content('редактирование')
    end
  end

  context 'should create new category' do
    scenario 'view new category form' do
      visit new_admin_category_path
      expect(page).to have_content('новая категория')
    end

    scenario 'create category with parent'
    scenario 'create root category'
  end
end