Rails.application.routes.draw do
	



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'
	get 'static_pages/front_page_text' 
  #get 'static_pages/home'
end
