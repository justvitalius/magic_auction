MagicAuction::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'user/registrations' }

  root 'auctions#index'

  resources :categories
  resources :products
  resources :auctions
end
