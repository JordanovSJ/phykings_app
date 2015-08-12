Rails.application.routes.draw do
	# The second argument defines the place of the controller that is going to handle the
	# omniauth callback.
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  
  mathjax 'mathjax'
  
  get "static_pages/click_home"
  get "static_pages/click_competition"
  get "static_pages/click_p_and_s"
  get "static_pages/click_help"
  
  resources :users, only: [:show] do
		collection do
			get "show_stats"
		end
	end

  root 'static_pages#home'
	
	resources :problems 
end
