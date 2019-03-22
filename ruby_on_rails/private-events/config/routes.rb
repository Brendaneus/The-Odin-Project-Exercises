Rails.application.routes.draw do
  get		'/signin',                to: 'sessions#new'
  post		'/signin',				      to: 'sessions#create'
  delete	'/signout',				      to: 'sessions#destroy'
  resources	:users,					      only: [:show, :new, :create]
  resources :events,				      only: [:index, :show, :new, :create] do
  	resources :invitations,			  only: [:new, :create]
  	get	'/attend/:user_id',		  to: 'attendances#create'
  	delete	'/unattend/:user_id',	to: 'attendances#destroy'
  end
  resources :invitations,			    only: [:index, :show, :destroy]
end
