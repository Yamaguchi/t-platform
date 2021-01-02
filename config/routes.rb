Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: "dashboards#index"

  get :dashboard, to: 'dashboards#index'

  resources :users, only: [:index, :show, :edit] do
    patch '/edit', to: 'users#update', on: :member
    resources :roles, only: [:new, :destroy], module: :users do
      post '/new', to: 'roles#create', on: :collection
    end
  end

  resources :organization_units, only: [:show, :index]
  resources :roles, only: [:index, :show, :new, :edit, :destroy] do
    post '/new', to: 'roles#create', on: :collection
    patch '/edit', to: 'roles#update', on: :member
    resources :entity_privileges, only: [:new, :edit, :destroy], module: :roles do
      post '/new', to: 'entity_privileges#create', on: :collection
      patch '/edit', to: 'entity_privileges#update', on: :member
    end
    resources :users, only: [:new, :destroy], module: :roles do
      post '/new', to: 'users#create', on: :collection
    end
  end

  resources :tokens, only: [:index, :show]

  resources :wallets, only: [:create] do
    resources :tokens, only: [:new, :show, :edit], module: :wallets do
      post '/new', to: 'tokens#create', on: :collection
      post '/edit', to: 'tokens#update', on: :member
      post '/reissue', to: 'tokens#reissue!', on: :member
      get '/reissue', to: 'tokens#reissue', on: :member
      post '/transfer', to: 'tokens#transfer!', on: :member
      get '/transfer', to: 'tokens#transfer', on: :member
    end
  end
end
