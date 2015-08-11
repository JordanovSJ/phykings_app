class SolutionsController < ApplicationController
	before_action :logged_in_user
	before_action :current_problem , only: [:new]  # add create ??#consider change name
	before_action :has_no_solution_do, only: [:create, :new]
	before_action :has_solution_do, only: [:edit, :update, :delete] #delete?	
	#add this when finish valid relation
	#before_action :permitted_to_submit_solution, only: [:create, :new]
	
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
      flash[:success] = "Solution created!"
      redirect_to solution_path(@solution)
    else
      render 'new'
		end
	end
	
	def edit
		@solution=Solution.find(params[:id])
	end
	
	def update
	end
	
	def destroy
	end
	
	private
	
	def solution_params
     params.require(:solution).permit(:content, :degree_of_answer, :units_of_answer, :answer)
  end
  
  #returns user_problem_relation if one already exists or create a new one
  def current_relation
		if current_user.seen_problems.include?(current_problem)
			relation=current_user.user_problem_relations.find_by(seen_problem_id: current_problem.id)
			#relation.update_attributes(provided_with_solution: true)
		else 
			relation=current_user.user_problem_relations.create!(seen_problem_id: current_problem.id, 
																														provided_with_solution: true)
		end
		return relation
  end
  
  #obviously returns true if the current user has submitted solution for the problem
  def has_solution? #need fix
		if current_user.user_problem_relations.find_by(seen_problem_id: current_problem.id).nil?
			return false
		else
			current_user.user_problem_relations.find_by(seen_problem_id: current_problem.id).provided_with_solution
		end
  end
  
  #check if the problem has already a solution and if yes redirects to edit instead
  def has_no_solution_do # && !current_user.admin?
		if has_solution?			
			flash[:danger] = "You have alreadu submitted solution for this problem!"
			solution_id=current_user.user_problem_relations.find_by(seen_problem_id: current_problem.id).solution.id #add mehtod current_solution
			redirect_to  :controller => 'solutions', :action => 'edit', :id => solution_id , :problem_id => params[:problem_id] #!!!!!!!!!!!!!!
		end
	end
	
  #check if the problem has already a solution and if no redirects to new instead
	def has_solution_do
		if !has_solution? # && !current_user.admin?
			redirect_to  :controller => 'solutions', :action => 'new', :problem_id => params[:problem_id] #not tested
		end
	end
	
	#obvious
	def current_problem #TODO replace with this method wherevere u see Problem.find(params[:problem_id]
		if !params[:problem_id].nil?
			@current_problem=Problem.find(params[:problem_id])
		else
			flash[:danger] = "Problem not found"
			redirect_to root_path
			
		end
	end
	
	#TODO in distant future
	#check if the user is allowed to submit solution
	#only a user that has participated in premium competition or has submitted a solution immidiately after a free competition is allowed to do stuff here
	#need to add some attribute relation to determine if user has just finished competition
	def valid_relation
		
	end
	
	#Finish in future
	def permitted_to_submit_solution
		unless current_problem.solutions.count==0 || current_user==current_problem.creator # || current_user.admin? || valid_relation
			flash[:danger] = "You are not allowed to submitted a solution of this problem becauese of some reason?!?!"
			redirect_to root_path
		end
	end
end

