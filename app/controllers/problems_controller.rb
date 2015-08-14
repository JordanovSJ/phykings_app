class ProblemsController < ApplicationController
	
	#makes sure only a logged_in user can access problem actions
	before_action :logged_in_user
	#only the creator of the problem or an admin are allowed to edit/delete the problem
	before_action :can_edit_delete_update_problem, only: [:edit, :destroy, :update]
	#only people who have solved the problem, its creator or an admin is can see the problem
	before_action :can_see_problem, only: [:show]
	
	def show
		@problem=Problem.find(params[:id])
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
	
	def show_solutions
		@solutions = Problem.find(params[:id]).solutions
	end
	
	def no_solutions
		@no_solutions = []
		Problem.all.each do |pr|
			if pr.solutions.empty?
				@no_solutions.push(pr)
			end
		end
	end
	
	private
	
  def problem_params
     params.require(:problem).permit(:content, :title, :answer, :degree_of_answer, :units_of_answer, :category, :difficulty, :length)
  end
		
		#its used to restrict the acces to the delete and edit action
	def can_edit_delete_update_problem
		unless current_user==Problem.find(params[:id]).creator #|| current_user.admin?
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
