MagicAuction::Application.routes.draw do

  devise_for :users

  root 'auctions#index'

  resources :categories
  resources :products
  resources :auctions
end
