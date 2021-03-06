class StaticPagesController < ApplicationController
	
	def home
		if !user_signed_in?
			render 'homescreen'
		end
	end
	
	def click_home
		# Remember the new sidebar
		session[:sidebar] = "profile"
		# Remember the new sidebar item
		session[:sidebar_item] = params[:sidebar_item]
		
		respond_to do |format|
			format.html { redirect_to root_url }
			format.js
		end
	end
	
	def click_competition
		# Remember the new sidebar
		session[:sidebar] = "competitions"
		# Remember the new sidebar item
		session[:sidebar_item] = params[:sidebar_item]
		
		respond_to do |format|
			format.html { redirect_to root_url }
			format.js
		end
	end
	
	def click_p_and_s
		# Remember the new sidebar
		session[:sidebar] = "p_and_s"
		# Remember the new sidebar item
		session[:sidebar_item] = params[:sidebar_item]
		
		respond_to do |format|
			format.html { redirect_to root_url }
			format.js
		end
	end

	def click_help
		# Remember the new sidebar
		session[:sidebar] = "help"
		# Remember the new sidebar item
		session[:sidebar_item] = params[:sidebar_item]
		
		respond_to do |format|
			format.html { redirect_to root_url }
			format.js
		end
	end
	
	def click_admin
		# Remember the new sidebar
		session[:sidebar] = "admin"
		# Remember the new sidebar item
		session[:sidebar_item] = params[:sidebar_item]
		
		respond_to do |format|
			format.html { redirect_to root_url }
			format.js
		end
	end
	
	def latex_guide
	
	end
	
	def rules
	
	end
	
	def mission
	
	end
	
	def about
	
	end
	
	def buy_gold
		current_user.increment(:times_buy_gold).save!
	end
	
end

