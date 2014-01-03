MagicAuction::Application.routes.draw do

  resources :categories
  resources :products
  resources :auctions
end
