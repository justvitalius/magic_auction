FactoryGirl.define do
  factory :auction do
    title 'auction'
    expire_date DateTime.now + 1.month
    start_date DateTime.now
    product


    factory :auction_with_images do
      title 'auction'
      expire_date DateTime.now + 1.month
      start_date DateTime.now

      product { FactoryGirl.create(:product_with_images) }
    end
  end
end