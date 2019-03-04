Rails.application.routes.draw do
	get '/signin',	to: 'sessions#new'
	post '/signin',	to: 'sessions#create'
	delete '/signout', to: 'sessions#destroy'
	resources :posts, only: [:index, :new, :create]
end
