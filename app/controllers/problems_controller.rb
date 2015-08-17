class ProblemsController < ApplicationController
	include ApplicationHelper
	
	#makes sure only a logged_in user can access problem actions
	before_action :logged_in_user
	#only the creator of the problem or an admin are allowed to edit/delete the problem
	before_action :can_edit_delete_update_problem, only: [:edit, :destroy, :update]
	#only people who have solved the problem, its creator or an admin is can see the problem
	before_action :can_see_problem, only: [:show]
	
	def show
		@problem = current_problem
		@relation = current_relation
	end
	
	def new
		@problem=Problem.new #why??
		# Categories to be displayed in the views selection boxes
	end
	
	def create
			@problem =current_user.uploaded_problems.build(problem_params)
    if @problem.save
      flash[:success] = "Problem created!"
      redirect_to problem_path(@problem)
      #redirect_to previous locataion
    else
      render 'new'
    end	
   end
	
	def edit
		@problem=Problem.find(params[:id])
	end
	
	def update
	  @problem = Problem.find(params[:id])
    if @problem.update_attributes(problem_params)
      flash[:success] = "Problem updated"
      redirect_to @problem
    else
      render 'edit'
    end
	end
	
	def destroy	
		Problem.find(params[:id]).destroy
    flash[:success] = "Problem deleted"
    redirect_to root_path #previous location
	end
	
	# Used to show the solutions of the current problem
	def show_solutions
		@normal_solutions = current_problem.solutions.where(reported: false)
		@reported_solutions = current_problem.solutions.where(reported: true)
	end
	
	# Used for the "Problems without solution" view
	def no_solutions
		@no_solutions = []
		Problem.all.each do |pr|
			if pr.solutions.empty?
				@no_solutions.push(pr)
			end
		end
	end
	
	# Sends a vote to the current relation
	def vote
		relation = current_relation
		problem = current_problem
		
		unless relation.voted?
			relation.update_attributes( rating: vote_params[:rating],
																	length: vote_params[:length],
																	difficulty: vote_params[:difficulty],
																	voted: true )
			problem.increment( :votes, 1 ).save!
			
			# Every VOTES_REFRESH votes the problem parameters will refresh
			if problem.votes % VOTES_REFRESH == 0
				rel_array = problem.user_problem_relations.where(voted: true)
				sum_rating, sum_length, sum_difficulty = 0.0, 0, 0
				count = rel_array.count
				
				rel_array.each do |rel|
					sum_rating += rel.rating
					sum_length += rel.length
					sum_difficulty += rel.difficulty
				end
				
				new_rating = sum_rating / count # Float
				new_length = sum_length / count # Integer
				new_difficulty = sum_difficulty / count # Integer
				
				problem.update_attributes(rating: new_rating, length: new_length, difficulty: new_difficulty)	
			end
			flash[:success] = "Thank you for rating this problem."
			redirect_to problem_path(problem)
		else
			flash[:danger] = "You have already rated this problem."
			redirect_to problem_path(problem)
		end
	end
	
	private
	
  def problem_params
     params.require(:problem).permit(:content, :title, :answer, :degree_of_answer, :units_of_answer, :category, :difficulty, :length)
  end
  
  def vote_params
		params.require(:vote).permit(:rating, :length, :difficulty)
  end
		
		#its used to restrict the acces to the delete and edit action
	def can_edit_delete_update_problem
		unless current_user==Problem.find(params[:id]).creator || current_user.admin?
			flash[:danger] = "You are not allowed to edit/delete this problem"
      redirect_to root_path
		end			
	end
	
		#it is used to restrict the access to the show action
	def can_see_problem
	#need to fix this after add type to user_problem_relations
		unless current_user.relation_of(Problem.find(params[:id])).present? || 
					current_user==Problem.find(params[:id]).creator || Problem.find(params[:id]).solutions.count==0#|| current_user.admin?
					
			flash[:danger] = "You are not allowed to see this problem"
      redirect_to root_path
		end
	end
	
	
end
