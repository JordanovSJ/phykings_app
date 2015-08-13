class UsersController < ApplicationController

	def show
		if User.where(id: params[:id]).present?
			@user = User.find(params[:id])
		else
			flash[:danger] = "The requested user does not exist."
			redirect_to root_path
		end
	end
	
	def show_stats
	
	end
	
	def my_problems
		@my_problems = current_user.uploaded_problems
	end
	
	def my_solutions
		@my_solutions = current_user.solutions
	end
	
	def seen_problems
		@seen_problems = current_user.seen_problems
	end

end
