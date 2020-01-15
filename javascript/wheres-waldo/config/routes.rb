Rails.application.routes.draw do
  root 'albums#index'

  resources :albums do
    resources :pictures, except: [:index] do
      get 'selections'
      resources :locations, except: [:show, :new, :edit]
      resources :scores, only: [:index, :create, :destroy] do
        get 'load', on: :member
        get 'quit', on: :collection
        get 'hints'
        get 'matches'
        post 'guess'
      end
    end
  end

  resources :characters

  resources :users do
    resources :scores
  end

  # Sessions
  get 'login', to: 'sessions#new_login'
  post 'login', to: 'sessions#login'
  get 'logout', to: 'sessions#logout'
end
