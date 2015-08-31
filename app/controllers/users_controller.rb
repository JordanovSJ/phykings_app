class UsersController < ApplicationController
	include TransactionsHelper
	
	
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

		@free_efficiency = 0.0
		@premium_efficiency = 0.0
		
		@free_number_of_games = current_user.number_free_games
		@free_attempted = current_user.user_problem_relations.where(attempted_during_free: true).count
		@free_solved = current_user.user_problem_relations.where(solved_during_free: true).count
		if @free_attempted != 0
			@free_efficiency = @free_solved * 100/ @free_attempted
		end
		
		@premium_number_of_games = current_user.number_premium_games
		@premium_attempted = current_user.user_problem_relations.where(attempted_during_premium: true).count
		@premium_solved = current_user.user_problem_relations.where(solved_during_premium: true).count
		if @premium_attempted != 0
			@premium_efficiency = @premium_solved * 100/ @premium_attempted
		end
		
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

	def free_gold
		n_solved_problems=current_user.user_problem_relations.select{|r| (r.solved_during_free || r.solved_during_premium)}.count
		if  (n_solved_problems >= N_PROBLEMS_FREE_GOLD) && !current_user.got_free_gold?
			ActiveRecord::Base.transaction do
				add_gold_to_user(FREE_GOLD, current_user)
				current_user.update_attributes!(got_free_gold: true)
			end
			flash[:success]="You got #{FREE_GOLD} free gold"
			redirect_to user_path(current_user)
		else
			flash[:danger]="You cannot get free gold"
			redirect_to root_path
		end
	end
end
