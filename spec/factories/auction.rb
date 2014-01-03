FactoryGirl.define do
  factory :auction do
    title 'auction'
    expire_date DateTime.now + 1.year
    product
  end
end