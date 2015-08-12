class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
	end
	
	def show_stats
	
	end
	
	def my_problems
		@my_problems = current_user.uploaded_problems
	end

end
