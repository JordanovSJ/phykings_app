class ProblemsController < ApplicationController
	
	#makes sure only a logged_in user can access problem actions
	before_action :logged_in_user
	#only the creator of the problem or an admin are allowed to edit/delete the problem
	before_action :creator_or_admin, only: [:edit, :destroy, :update]
	#only people who have solved the problem, its creator or an admin is can see the problem
	before_action :creator_viewer_or_admin, only: [:show]
	
	def show
		@problem=Problem.find(params[:id])
	end
	
	def new
		@problem=Problem.new #why??
	end
	
	def create
		if !current_user.nil?
			@problem =current_user.uploaded_problems.build(problem_params)
    end
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
	
	private
	
  def problem_params
     params.require(:problem).permit(:content, :title, :answer)
  end
		
		#its used to restrict the acces to the delete and edit action
	def creator_or_admin
		unless current_user==Problem.find(params[:id]).creator #|| current_user.admin?
			flash[:danger] = "You are not allowed to edit/delete this problem"
      redirect_to root_path
		end			
	end
	
		#it is used to restrict the access to the show action
	def creator_viewer_or_admin
	#need to fix this after add type to user_problem_relations
		unless Problem.find(params[:id]).viewers.include?(current_user) || 
					current_user==Problem.find(params[:id]).creator #|| current_user.admin?
			flash[:danger] = "You are not allowed to see this problem"
      redirect_to root_path
		end
	end
	
	
end
