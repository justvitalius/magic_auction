MagicAuction::Application.routes.draw do

  devise_for :users, controllers: {registrations: 'user/registrations', omniauth_callbacks: 'omniauth_callbacks'}

  root 'site#index'
  #get '/' => 'admin/auctions#index', as: :user_root

  namespace 'admin' do
    root 'auctions#index'
    resources :categories, except: [:show]
    resources :products, except: [:show]
    resources :auctions, except: [:show]
  end

  resources :auctions, only: [:show] do
    resources :bets, only: [:create]
  end
  resource :profile

end
