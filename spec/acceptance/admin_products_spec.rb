require 'acceptance/acceptance_helper'

feature "Admin manage products", %q{
  In order to manage auction's settings
  As an admin
  I want to manage products.
 } do

  let(:admin) { create(:admin) }
  let(:path) { admin_products_path }
  let(:collection_title) { 'товары' }
  let(:collection) { 3.times.map { |i| create(:product, title: "product-#{i}") } }

  it_behaves_like 'Admin_accessible'
  it_behaves_like 'Collection_listable'


  describe 'should work with admin area' do
    background do
      prepare_testing_area
    end

    context 'should edit exists products' do
      background do
        create(:product)
      end

      scenario 'edit exists product' do
        visit admin_products_path
        #save_and_open_page
        click_on 'редактировать'
        expect(page).to have_content('редактирование')
      end
    end

    context 'should create new product' do
      scenario 'view new product form' do
        visit new_admin_product_path
        expect(page).to have_content('новый товар')
      end
    end
  end
end