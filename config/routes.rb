MagicAuction::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'user/registrations' }

  root 'site#index'
  get 'admin' => 'admin/auctions#index', as: :user_root

  namespace 'admin' do
    resources :categories
    resources :products
    resources :auctions
  end
end
