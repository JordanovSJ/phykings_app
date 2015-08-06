class StaticPagesController < ApplicationController
	
	def home
		 
	end
	
	def front_page_text
			#@front_page_text_partial=params[:info_partial]
			render 'home'
			#redirect_to root_url
	end
	
	def about
	end
	
	private

end

