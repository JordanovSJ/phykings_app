class OmniauthCallbacksController < Devise::OmniauthCallbacksController


	# This method handles the callback from facebook. The code is taken
	# from the Devise OmniAuth Overview documentation
	def facebook
	
    # This method is implemented in app/models/user.rb
    @user = User.from_omniauth(request.env["omniauth.auth"])
		
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url #redirects to sign up if unsuccessful
    end
  end

end
