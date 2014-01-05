MagicAuction::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'user/registrations' }

  root 'site#index'
  get 'admin' => 'admin/auctions#index', as: :user_root

  namespace 'admin' do
    #get 'auctions#index', as: :root
    root 'auctions#index'
    resources :categories,  except: [:show]
    resources :products,    except: [:show]
    resources :auctions,    except: [:show]
  end
end
