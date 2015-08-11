Rails.application.routes.draw do
	# The second argument defines the place of the controller that is going to handle the
	# omniauth callback.
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  
  

  root 'static_pages#home'
	get 'static_pages/front_page_text'
	
	resources :problems 
	resources :solutions 
  
  
end
