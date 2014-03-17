# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do
    title 'Permission'
    action 'manage'

    factory :manage_categories do
      title 'Управление категорями'
      subject 'Category'
    end

    factory :manage_products do
      title 'Управление продуктами'
      subject 'Product'
    end

  end
end
