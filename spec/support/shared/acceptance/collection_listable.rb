shared_examples_for 'Collection_listable' do
  background do
    #visit new_user_session_path
    #sign_in_with admin.email, '12345678'
    prepare_testing_area
    #visit path
  end

  scenario 'should render collection list' do
    expect(page).to_not have_content('редактировать')
    expect(page).to_not have_content('редактирование')
    expect(page).to have_content(collection_title)
    expect(current_path).to eq(path)

    collection

    visit path

    collection.each do |c|
      expect(page).to have_content c.title
    end
    expect(page).to have_content('редактировать')
  end

end