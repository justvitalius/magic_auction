FactoryGirl.define do
  factory :product do
    title 'product'
    description 'product description'
    price 100.00

    factory :product_with_images do
      title 'product with images'
      price 100.00

      ignore do
        images_count 5
      end

      after(:create) do |pr, ev|
        create_list(:product_image, ev.images_count, product: pr)
      end
    end
  end
end