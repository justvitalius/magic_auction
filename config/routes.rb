MagicAuction::Application.routes.draw do

  devise_for :users
  resources :categories
  resources :products
  resources :auctions
end
