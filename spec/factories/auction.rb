FactoryGirl.define do
  factory :auction do
    title 'auction'
    expire_date DateTime.now + 1.month
    # TODO: почему-то здесь задаем DateTime.now и ошибка,
    # а когда также задано при тестировании вьюхи, то ошибка не вылетает,
    # поэтому тут мы задаем время DateTime.now + 1.days
    start_date DateTime.now + 1.days
    product

    factory :auction_with_images do
      title 'auction'
      expire_date DateTime.now + 1.month
      start_date DateTime.now + 1.days
      product

      ignore do
        images_count 5
      end

      after(:create) do |a, ev|
        create_list(:product_image, ev.images_count, product: a.product)
      end
    end
  end
end