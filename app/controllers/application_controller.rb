class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # This was taken from the Devise documentation to allow for 
  # additional fields in the registration form
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def index
		render 'static_pages/index'
  end
  
  protected
  
	# This was also taken from the Devise documentation to allow
	# for additional fields in the registration form
	def configure_permitted_parameters
		# Allow these fields to be filled in during sign up.
		devise_parameter_sanitizer.for(:sign_up) << :first_name
		devise_parameter_sanitizer.for(:sign_up) << :last_name
		devise_parameter_sanitizer.for(:sign_up) << :age
		devise_parameter_sanitizer.for(:sign_up) << :country
		devise_parameter_sanitizer.for(:sign_up) << :school_name
																								
		# Allow these fields to be filled in during an account update.
		devise_parameter_sanitizer.for(:account_update) << :first_name
		devise_parameter_sanitizer.for(:account_update) << :last_name
		devise_parameter_sanitizer.for(:account_update) << :age
		devise_parameter_sanitizer.for(:account_update) << :country
		devise_parameter_sanitizer.for(:account_update) << :school_name
	end
	
	# Confirms a logged-in user.
	def logged_in_user
	
		unless user_signed_in?
			#store_location
			flash[:danger] = "Please log in."
			redirect_to new_user_session_path
		end
	end
	
	def logged_in_as_admin_or_moderator
		unless current_user.admin? || current_user.moderator?
			flash[:danger] = "Please log in as admin or moderator."
			redirect_to root_path
		end
	end
  

end
