Rails.application.routes.draw do
	# The second argument defines the place of the controller that is going to handle the
	# omniauth callback.
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  
  get "static_pages/click_home"
  get "static_pages/click_competition"
  get "static_pages/click_p_and_s"
  get "static_pages/click_help"
  
  resources :users, only: [:show] do
		collection do
			get "show_stats"
		end
	end

  # You can have the root of your site routed with "root"
  #~ root 'application#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  root 'static_pages#home'
  #get 'static_pages/home'
	
	resources :problems 
end
