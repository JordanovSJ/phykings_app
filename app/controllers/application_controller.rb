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
			devise_parameter_sanitizer.for(:sign_up) << :username
		end
  
end
