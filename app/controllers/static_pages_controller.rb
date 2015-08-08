class StaticPagesController < ApplicationController
	
	def home
		if !user_signed_in?
			render 'homescreen'
		end
	end
	
	def front_page_text
			render 'home'	
	end
	
	def click_home
		respond_to do |format|
			format.js
		end
	end
	
	def click_competition
		respond_to do |format|
			format.js
		end
	end
	
	def click_p_and_s
		respond_to do |format|
			format.js
		end
	end

	def click_help
		respond_to do |format|
			format.js
		end
	end
	
end

