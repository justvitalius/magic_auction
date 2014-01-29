require 'acceptance/acceptance_helper'

feature "Admin manage auctions", %q{
  In order to manage auction's settings
  As an admin
  I want to view, create, edit and delete auctions.
 } do

  let(:path){ admin_auctions_path }
  let!(:admin){ create(:admin) }
  let(:collection){ 3.times.map{ |i| create(:auction, title: "auction-#{i}") } }
  let(:collection_title){ 'аукционы' }


  it_behaves_like 'Admin_accessible'
  it_behaves_like 'Collection_listable'


  describe 'work with admin area' do
    background  do
      prepare_testing_area
    end

    context 'should create new auction' do
      background do
        @product = create(:product, title: 'product for auction')
      end


      describe 'ajax', js: true do

        context 'view and interact new auction form'do
          background do
            visit new_admin_auction_path
          end

          scenario 'load form with default states of UI controls' do
            expect(page).to have_content('создать новый продукт')
            expect(page).to_not have_content('не создавать этот продукт')
            expect(page).to have_content('новый аукцион')
            expect(page.all('select:disabled').count).to eq(0)
            expect(current_path).to eq(new_admin_auction_path)
          end

          scenario 'click on add_product' do
            click_on 'создать новый продукт'

            expect(page).to_not have_content('создать новый продукт')
            expect(page).to have_content('не создавать этот продукт')
            expect(page.all('.spec-product-fields').count).to eq(1)
            expect(page.all('select:disabled').count).to eq(1)
          end

          scenario 'click on delete_product' do
            click_on 'создать новый продукт'
            click_on 'не создавать этот продукт'

            expect(page).to have_content('создать новый продукт')
            expect(page).to_not have_content('не создавать этот продукт')
            expect(page.all('select:disabled').count).to eq(0)
            expect(page.all('.spec-product-fields').count).to eq(1)
          end
        end

        # TODO: следующие два теста очень странные.
        # Если выводить страницу через save_and_open_page,
        # то все инпуты пусты, но при этом итоговое сохранение проходит
        context 'create new valid auction and product together' do
          background do
            category = create(:category)

            visit new_admin_auction_path
            # fill auction fields
            fill_in 'название', with: 'аукцион 1'
            select_datetime (DateTime.now + 1.month), from: 'дата окончания'
            select_datetime DateTime.now, from: 'дата начала'
            # fill product fields
            click_on 'создать новый продукт'

            within('.spec-product-fields') do
              fill_in 'название', with: 'product from auction'
              fill_in 'цена', with: '0.01'
              all("input[type=radio][value='#{category.id}']").map(&:click)
            end
          end

          scenario 'should create new one Product' do
            expect(page.all('select:disabled').count).to_not eq(0)
            expect{ click_on 'сохранить' }.to change(Product, :count).by(1)
            expect(current_path).to eq(admin_auctions_path)
          end

          scenario 'should create new one Auction' do
            save_and_open_page
            expect(page.all('select:disabled').count).to_not eq(0)
            expect{ click_on 'сохранить' }.to change(Auction, :count).by(1)
            expect(current_path).to eq(admin_auctions_path)
          end
        end

        scenario 'tries to create new valid auction and invalid product together' do
          category = create(:category)

          visit new_admin_auction_path
          # fill auction fields
          fill_in 'название', with: 'аукцион 1'

          # TODO: почему он здесь не выбирает дату? Т.е.он вставляет только
          select_datetime (DateTime.now + 1.month), from: 'дата окончания'
          select_datetime (DateTime.now), from: 'дата начала'
          # fill product fields
          click_on 'создать новый продукт'

          within('.spec-product-fields') do
            fill_in 'название', with: 'product from auction'
            #fill_in 'цена', with: '0.01'
            all("input[type=radio][value='#{category.id}']").map(&:click)
          end
          expect{ click_on 'сохранить' }.to change(Product, :count).by(0)
          expect(page.all('select:disabled').count).to_not eq(0)
          expect(current_path).to eq(admin_auctions_path)
        end
      end

      # TODO: данный тест странный. Он проходит, но если загрузить страницу в браузере, то на месте выбора Продукта из ниспадающего списка два варианта ДА/НЕТ
      scenario 'create new valid auction with existed product' do
        visit new_admin_auction_path

        fill_in 'название', with: 'аукцион 1'
        select_datetime (DateTime.now + 2.month), from: 'дата окончания'
        select_datetime (DateTime.now + 1.days), from: 'дата начала'
        select @product.title, from: 'товар'
        #save_and_open_page
        #click_on 'сохранить'
        expect{ click_on 'сохранить' }.to change(Auction, :count).by(1)
        expect(current_path).to eq(admin_auctions_path)
        expect(page).to have_content('аукционы')
      end

      scenario 'tries to create new invalid auction with existed product' do
        visit new_admin_auction_path

        fill_in 'название', with: 'аукцион 1'
        select_datetime (DateTime.now - 1.month), from: 'дата окончания'
        click_on 'сохранить'

        expect(page).to have_content('новый аукцион')
      end
    end

    context 'should edit existed auction' do
      describe 'ajax', js: true do
        context 'view and interact existed auction form' do
          let(:auction){ create(:auction) }
          let(:product){ create(:product) }

          scenario 'load form with default states of UI controls' do
            visit edit_admin_auction_path(auction)

            expect(page).to_not have_content('создать новый продукт')
            expect(page).to_not have_content('не создавать этот продукт')
            expect(page).to have_content('редактирование')
            expect(page.all('select:disabled').count).to eq(0)
            expect(current_path).to eq(edit_admin_auction_path(auction))
          end
        end
      end
    end
  end
end