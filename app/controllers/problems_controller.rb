class ProblemsController < ApplicationController
	include ApplicationHelper
	
	#makes sure only a logged_in user can access problem actions
	before_action :logged_in_user
	before_action :check_for_id, only: [:show , :edit, :update, :delete]
	#only the creator of the problem or an admin are allowed to edit/delete the problem
	before_action :can_edit_delete_update_problem, only: [:edit, :destroy, :update]
	#only people who have solved the problem, its creator or an admin is can see the problem
	before_action :can_see_problem, only: [:show]
	
	def show
		@problem = current_problem
		@relation = current_relation
	end
	
	def new
		@problem=Problem.new 
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
			update_solutions
			solution=current_user.solution_of(@problem)
			if solution.present? && solution.reported
				#~ redirect_to edit_solution_path(solution)
				#~ flash[:danger]= "Problem updated, but your solution to this problem has unconsistent answer!!! Please edit your solution !"
				current_user.notifications.create!(message: "Your solution to problem #{@problem.title} has unconsistent answer and its status is now reported!!! Please edit your solution!!!")
				redirect_to @problem
			else
				flash[:success] = "Problem updated"
				redirect_to @problem
			end
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
		@normal_solutions = current_problem.solutions.where(reported: false)
		@reported_solutions = current_problem.solutions.where(reported: true)
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
	
	  #checks if params[:id] exist
  def check_for_id
		if Problem.where(id: params[:id]).count==0
			flash[:danger]="This problem does not exist"
			redirect_to root_path
		end
  end
		
			#when problem is update checks if the answers of its solutions are still consistent with the answer of the problem and
			# change them to reports if not
	def update_solutions
		solutions=@problem.solutions
		solutions.each do |s|
			solution_params=s.answer_params
			#change normal solution to report
			if !Solution.check_answer(solution_params,@problem) && !s.reported
				s.update_attributes(reported: true)
			end
			#change report to normal solution
			if Solution.check_answer(solution_params,@problem) && s.reported
				s.update_attributes(reported: false)
			end
		end
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
