class UsersController < ApplicationController

	before_action :logged_in_user
	before_action :logged_in_as_admin_or_moderator, only: [:admin_users, :admin_problems, :admin_solutions]

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
	
	def show_notifications
		@notifications = current_user.notifications
	end
	
	def admin_users
		@admin_users = User.all
	end
	
	def admin_problems
		@admin_problems = Problem.all
	end
	
	def admin_solutions
		@admin_solutions = Solution.all
	end


end
