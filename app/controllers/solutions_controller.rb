class SolutionsController < ApplicationController
	include ApplicationHelper
	
	before_action :logged_in_user
	before_action :permitted_to_submit_report , only: [:create]
	before_action :current_problem_nil , only: [:new, :create]
	before_action :has_solution, only: [:create, :new]
	before_action :permitted_to_submit_solution, only: [:create, :new]
	before_action :permitted_to_update_report , only: [:update]
	before_action :check_for_id, only: [:show , :edit, :update, :delete]
	before_action :permitted_to_see_solution, only: [:show]
	before_action :permitted_to_change_delete_solution, only: [:edit, :update, :destroy]


	
	def index
	
	end
	
	def show
		@solution=Solution.find(params[:id])
	end
	
	def new
		@solution=Solution.new
	end
	
	def create
		@solution =current_user.solutions.build(solution_params)
		@relation=current_relation
		@solution.user_problem_relation_id=@relation.id
    if @solution.save
			@relation.update_attributes(provided_with_solution: true)
      redirect_to solution_path(@solution)
      #if the answer of the solution is different than that of the problem the create action change the value reported to TRUE
      if Solution.check_answer(solution_params,current_problem)
				flash[:success] = "Solution submitted successfully."
			else
				@solution.update_attributes(reported: true)
				flash[:success] = "Report solution submitted successfully."
			end
    else
      render 'new'
		end
	end
	
	def edit
		@solution=Solution.find(params[:id])
	end
	
	# Updates the solution and checks if its reported status should change.
	def update
		  @solution = Solution.find(params[:id])
    if @solution.update_attributes(solution_params)
			if @solution.reported
				if Solution.check_answer(solution_params, @solution.problem)
					@solution.update_attributes(reported: false)
					flash[:success] = "Solution updated. Its status is now changed from Report to Normal."
				else
					flash[:success] = "Report solution updated!"
				end
			else
				if Solution.check_answer(solution_params,@solution.problem)
					flash[:success] = "Solution updated!"
				else
					@solution.update_attributes(reported: true)
					flash[:success] = "Solution updated. Its status is now changed form Normal to Report."
				end
			end
			redirect_to @solution
    else
      render 'edit'
    end
	end
	
	def destroy
		solution=Solution.find(params[:id])
		solution.user_problem_relation.update_attributes(provided_with_solution: false)
		solution.destroy
    flash[:success] = "Solution deleted"
    redirect_to root_path #previous location
	end
	
	private
	
	def solution_params
     params.require(:solution).permit(:content, :degree_of_answer, :answer)
  end
  
  #checks if params[:id] exist
  def check_for_id
		if Solution.where(id: params[:id]).count==0
			flash[:danger]="This solution does not exist"
			redirect_to root_path
		end
  end
  
  # MOved the current_relation method to the ApplicationHelper since
  # it is needed in the problems controller as well.
  
  #obviously returns true if the current user has submitted solution for the problem
  def has_solution
		if !current_user.relation_of(current_problem).nil? && current_user.relation_of(current_problem).provided_with_solution           
			flash[:danger] = "You have already submitted solution for this problem!"
			solution_id=current_user.solution_of(current_problem).id														
			redirect_to  :controller => 'solutions', :action => 'edit', :id => solution_id , :problem_id => params[:problem_id] #!!!!!!!!!!!!!!
		end
  end

	
	# Moved the current_problem method to the ApplicationHelper since
	# it is needed in the problems controller as well.
	#TODO replace with this method wherevere u see Problem.find(params[:problem_id]
	
	#obvious
	def current_problem_nil
		if 	params[:problem_id].nil?
			flash[:danger] = "Problem not found"
			redirect_to root_path		
		end
	end
	
	


	#check if the user is allowed to submit solution
	#before action method for new and create only
	def permitted_to_submit_solution
		unless current_problem.solutions.count==0 || current_user==current_problem.creator || current_user.relation_of(current_problem).present?#valid_relation_new_create # || current_user.admin? 
			flash[:danger] = "You are not allowed to submitted a solution of this problem becauese of some reason?!?!"
			redirect_to root_path
		end
	end
	
	#creator of a problem cannot submit report to that problem
	def permitted_to_submit_report
		if current_user==current_problem.creator && !Solution.check_answer(solution_params,current_problem)
			flash[:danger] ="You cannot report your own problems! Edit or delete the problem instead!!!"
			redirect_to edit_problem_path(current_problem)
		end
	end
	
	#creator of a problem cannot change solution to report
	def permitted_to_update_report
		problem=Solution.find(params[:id]).problem
		if current_user==problem.creator && !Solution.check_answer(solution_params,problem)
			flash[:danger] ="You cannot report your own problems! Edit or delete the problem instead!!!"
			redirect_to edit_problem_path(problem)
		end
	end
	
	
	#does a relation allows a user to see a solution
	def valid_relation_show
		if current_user.relation_of(Solution.find(params[:id]).problem).present?
			relation=current_user.relation_of(Solution.find(params[:id]).problem)
			return relation.attempted_during_premium || relation.can_see_solution || relation.provided_with_solution
		end
		
		return false
	end
	
	#check if the user is allowed to see solution
	#before action method for show only	
	def permitted_to_see_solution
		unless current_user==Solution.find(params[:id]).problem.creator || valid_relation_show #|| current_user.admin?
			flash[:danger] = "You are not allowed to see this solution!!!"
			redirect_to root_path
		end
	end
	
	

	def permitted_to_change_delete_solution
		unless current_user==Solution.find(params[:id]).user || current_user.admin?
			flash[:danger] = "You are not allowed to change/delete this solution!!!"
			redirect_to root_path
		end		
	end
end

