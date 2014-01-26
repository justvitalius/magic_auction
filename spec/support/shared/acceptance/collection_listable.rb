shared_examples_for 'Collection_listable' do
  background do
    prepare_testing_area
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