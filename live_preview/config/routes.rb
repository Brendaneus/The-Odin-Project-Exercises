Rails.application.routes.draw do

	root 'courses#index'

	resources :courses, only: [:index, :show] do
		resources :projects, only: [:show]
	end

end
