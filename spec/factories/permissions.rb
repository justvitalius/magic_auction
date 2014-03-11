# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do

    factory :manage_categories do
      title 'Управление категорями'
      action 'manage'
      subject 'Category'
    end

    factory :manage_products do
      title 'Управление продуктами'
      action 'manage'
      subject 'Product'
    end

  end
end
