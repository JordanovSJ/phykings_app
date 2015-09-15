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
		@my_problems = current_user.uploaded_problems.paginate(page: params[:page], per_page: 10)
	end
	
	def my_solutions
		@my_solutions = current_user.solutions.paginate(page: params[:page], per_page: 10)
	end
	
	def seen_problems
		@seen_problems = current_user.seen_problems.paginate(page: params[:page], per_page: 10)
	end
	
	def show_notifications
		@notifications = current_user.notifications.paginate(page: params[:page], per_page: 10)
	end
	
	def admin_users
		@admin_users = User.paginate(page: params[:page], per_page: 10)
	end
	
	def admin_problems
		@admin_problems = Problem.paginate(page: params[:page], per_page: 10)
	end
	
	def admin_solutions
		@admin_solutions = Solution.paginate(page: params[:page], per_page: 10)
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
	
	def activate_trial	
		if current_user.trial_started_at.present?
			flash[:danger]="You have already used your trial!!!"
			redirect_to root_path
		else
			current_user.update_attributes!(trial_started_at: Time.now)
			flash[:success]="Your trial have just started!! It will finish after #{DAYS_TRIAL} days. Enjoy!!!"
			current_user.notifications.create!( message: "You activated yout trial!! It will last for #{DAYS_TRIAL} days.
																										During that time you can see the answers and the solutions of problems without unlocking them!!
																										However once your trial is over you will have to unlock the answers and the solutions of these
																										problems in order to se them." )
			redirect_to root_path
		end	
	end
	
end
