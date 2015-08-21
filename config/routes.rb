Rails.application.routes.draw do
  get 'competitions/new'

	# The second argument defines the place of the controller that is going to handle the
	# omniauth callback.
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  
  mathjax 'mathjax'
  
  get "static_pages/click_home"
  get "static_pages/click_competition"
  get "static_pages/click_p_and_s"
  get "static_pages/click_help"
  get "static_pages/click_admin"
  
  resources :users, only: [:show] do
		collection do
			get "show_stats"
			get "my_problems"
			get "my_solutions"
			get "seen_problems"
			get "notifications", to: "users#show_notifications", as: "notifications"
			get "admin_users"
			get "admin_problems"
			get "admin_solutions"
		end
	end

  root 'static_pages#home'
	
	resources :problems do
		collection do
			get ":id/solutions", to: "problems#show_solutions", as: "show_solutions"
			get "no_solutions"
			post "vote"
			post "unlock_answer"
			post "unlock_solution"
		end
	end

	resources :solutions do
		collection do
			post ":id/vote", to: "solutions#vote", as: "vote"
		end
	end		
  
  resources :competitions, only: [:new, :show, :create, :index] do
		collection do
			post "submit"
			get "leave" #not sure for get, maybe delete
		end
  end
  
end
