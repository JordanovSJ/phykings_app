class ProblemsController < ApplicationController
	include ApplicationHelper
	
	#makes sure only a logged_in user can access problem actions
	before_action :logged_in_user
	before_action :check_for_id, only: [:show , :edit, :update, :delete, :show_solutions]
	#only the creator of the problem or an admin are allowed to edit/delete the problem
	before_action :not_in_competition, except: [:new, :create ]
	before_action :can_edit_delete_update_problem, only: [:edit, :destroy, :update]
	#only people who have solved the problem, its creator or an admin is can see the problem
	before_action :can_see_problem, only: [:show, :vote, :show_solutions]
	# checks if the submitted vote parameters are valid
	before_action :valid_vote, only: [:vote]
	
	
	def show
		@problem = current_problem
		@relation = current_relation
		if @problem.creator_id == current_user.id
			if !@relation.can_see_solution?
				@relation.can_see_solution=true
				@relation.can_see_answer=true
				@relation.save!
			end
		end
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
		if Problem.find(params[:id]).competition_problems.count == 0
			Problem.find(params[:id]).destroy
			flash[:success] = "Problem deleted"
			redirect_to root_path #previous location
		else
			flash[:danger]="This problem is being solved in a competition. You must wait the competition to finish to delete the problem!!!"
			redirect_to problem_path(params[:id])
		end
	end
	
	# Used to show the solutions of the current problem
	def show_solutions
		@normal_solutions = current_problem.solutions.where(reported: false)
		@reported_solutions = current_problem.solutions.where(reported: true)
	end
	
	# Used for the "Problems without solution" view
	def no_solutions
		#~ @no_solutions = []
		#~ Problem.all.each do |pr|
			#~ if pr.solutions.empty? && pr.checked
				#~ @no_solutions.push(pr)
			#~ end
		#~ end
		
		@no_solutions = Problem.where(checked: true).select { |p| p.solutions.empty?}.paginate(page: params[:page], per_page: 10)

	end
	
	# Sends a vote to the current relation
	def vote
		@relation = current_relation
		@problem = current_problem
		@success = false
		
		unless @relation.voted?
			@relation.update_attributes( rating: vote_params[:rating],
																	 length: vote_params[:length],
																	 difficulty: vote_params[:difficulty],
																	 voted: true )
			@problem.increment( :votes, 1 ).save!
			@success = true
			
			@problem.creator.notifications.create!(message: "Someone rated your " + view_context.link_to( "problem", problem_path(@problem) ) + ".")
			
			# Every VOTES_REFRESH votes the problem parameters will be refreshed
			if @problem.votes % VOTES_REFRESH == 1
				rel_array = @problem.user_problem_relations.where(voted: true)
				sum_rating, sum_length, sum_difficulty = 0.0, 0, 0
				count = rel_array.count
				
				rel_array.each do |rel|
					sum_rating += rel.rating
					sum_length += rel.length
					sum_difficulty += rel.difficulty
				end
				
				# New parameters are the average of the existing votes
				new_rating = sum_rating / count # Float
				new_length = sum_length / count # Integer
				new_difficulty = sum_difficulty / count # Integer
				
				@problem.update_attributes(rating: new_rating, length: new_length, difficulty: new_difficulty)	
			end
			
			respond_to do |format|
				format.js
				format.html { flash[:success] = "Thank you for rating this problem."
											redirect_to problem_path(problem) }
			end

		else
			respond_to do |format|
				format.js { flash.now[:danger] = "You have already rated this problem." }
				format.html { flash[:danger] = "You have already rated this problem."
											redirect_to problem_path(problem)}
			end
		end
	end
	
	# Triggered by a button on Problem Show to unlock the answer
	def unlock_answer
		@problem = current_problem
		if !current_user.unlock_answer_of(@problem).nil?
			current_user.notifications.create!(message:"Answer of " + view_context.link_to( @problem.title, problem_path(@problem) ) + " was unlocked. #{COST_TO_UNLOCK_ANSWER} gold were deducted from your account balance.")
			respond_to do |format|
				format.js
				format.html { flash[:success] = "You successfully unlocked the answer of this problem." 
											redirect_to problem_path(@problem) }
			end
		else
			respond_to do |format|
				format.js { flash.now[:danger] = "There was a problem. The answer was not unlocked." }
				format.html { flash[:danger] = "There was a problem. The answer was not unlocked." 
											redirect_to problem_path(@problem) }
			end
		end
	end
	
	def unlock_solution
		@problem = current_problem
		if !current_user.unlock_solutions_of(@problem).nil?
			current_user.notifications.create!(message:"Solutions of " + view_context.link_to( @problem.title, problem_path(@problem) ) + " were unlocked. #{COST_TO_UNLOCK_SOLUTIONS} gold were deducted from your account balance.")
			respond_to do |format|
				format.js
				format.html { flash[:success] = "You successfully unlocked all solutions of this problem." 
											redirect_to show_solutions_problems_path(@problem) }
			end
		else
			respond_to do |format|
				format.js
				format.html { flash[:danger] = "There was a problem. Solutions were not unlocked." 
											redirect_to show_solutions_problems_path(@problem) }
			end
		end
	end
	
	def toggle_check
		if current_user.admin? || current_user.moderator?
			curr_problem = current_problem
			curr_problem.checked = !curr_problem.checked
			curr_problem.save!
			
			respond_to do |format|
				format.js {}
				format.html {
					flash[:success] = "Problem check status toggled."
					redirect_to problem_path(curr_problem)
				}
			end
		else
			flash[:danger] = "You are not allowed to check/uncheck problems"
		end
	end
	
	private
	
  def problem_params
     params.require(:problem).permit(:content, :title, :target, :answer, :degree_of_answer, :units_of_answer, :category, :difficulty, :length, :picture)
  end
  
  # Handles the params hash when rating problems.
  def vote_params
		params.require(:vote).permit(:rating, :length, :difficulty)
  end
  
  # Used as a before action to the method vote. Checks if the submitted
  # vote_params are present and if their values are allowed. This is
  # simpler than including separate model validations to the relations model.
  def valid_vote
		if ( vote_params[:rating].present? && 
				 vote_params[:length].present? && 
				 vote_params[:difficulty].present? )
			if ( vote_params[:rating].to_i.between?(1, 10)  && 
					 LENGTH.include?( vote_params[:length].to_i ) && 
					 vote_params[:difficulty].to_i.between?(1, MAX_DIFFICULTY) )
				return true
			else
				flash[:danger] = "One or more invalid vote parameters."
				redirect_to problem_path(current_problem)
			end	
		else
			flash[:danger] = "You need to include all three parameters in your vote."
			redirect_to problem_path(current_problem)
		end
  end

	  #checks if params[:id] exist
  def check_for_id
		if current_problem.nil?	#Problem.where(id: current_problem.id).count==0
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
		unless current_user==Problem.find(params[:id]).creator || current_user.admin?
			flash[:danger] = "You are not allowed to edit/delete this problem"
      redirect_to root_path
		end			
	end
	
		#it is used to restrict the access to the show action
	def can_see_problem
		curr_problem = current_problem
		if curr_problem.checked || current_user.id==curr_problem.creator.id ||current_user.admin? || current_user.moderator?	
			unless current_user.relation_of(curr_problem).present? || current_user.id==curr_problem.creator.id || curr_problem.solutions.count==0 ||current_user.admin? || current_user.moderator?				
				flash[:danger] = "You are not allowed to see this problem"
				redirect_to root_path
			end
		else
			flash[:danger] = "This problem is not checked!!! You cannoot see it!!!!"
			redirect_to root_path
		end
	end
	
	#a user in a competition cannot see problems that are in the competition
	def not_in_competition
		if current_user.competition_id.present?  && !current_user.admin?
			competition=Competition.find(current_user.competition_id)
			if competition.problems.include?(current_problem) && !competition.finished?
				flash[:danger]="You cannot see this problem while in competition!!!"
				redirect_to competition_path(competition)
			end
		end
	end
	
end
