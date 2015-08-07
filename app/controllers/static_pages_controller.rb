class StaticPagesController < ApplicationController
	
	def home
		 render 'homescreen'
	end
	
	def front_page_text
			render 'home'	
	end
	
	def about
	end
	
	private

end

