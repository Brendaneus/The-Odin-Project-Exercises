Rails.application.routes.draw do

	root 'courses#index'

	resources :courses, only: [:index, :show], param: :slug do
		resources :projects, only: [:show], param: :slug
	end

end
