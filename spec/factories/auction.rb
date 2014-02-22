FactoryGirl.define do
  factory :auction do
    sequence(:title) { |n| "auction-#{n}" }
    expire_date { DateTime.now + 3.month }
    finish_date { DateTime.now + 1.month }
    start_date { DateTime.now }
    price 0.00
    price_step 10.00
    time_step 60
    product


    factory :auction_with_images do
      sequence(:title) { |n| "imaged-auction-#{n}" }

      product { FactoryGirl.create(:product_with_images) }
    end

    factory :expires_auction do
      sequence(:title) { |n| "expired-auction-#{n}" }
      expire_date { DateTime.now - 5.month }
      start_date { DateTime.now - 6.months }
      to_create { |instance| instance.save(validate: false) }
    end
  end
end