module ApplicationHelper

	# Returns the current problem. This function was originally used in the
	# solutions controller, where it expected params[:problem_id].
	# Now the function is used also in the problems controller where the
	# expected parameter is params[:id].
	def current_problem
		if params.has_key?(:problem_id)
			@current_problem=Problem.find(params[:problem_id])
		elsif params.has_key?(:id)
			if Problem.where(id: params[:id]).count != 0
				@current_problem=Problem.find(params[:id])
			else
				return nil
			end
		end
		return @current_problem
	end
	
	#returns user_problem_relation, if one already exists, or creates a new one
  def current_relation
		# Define a variable that will hold the current problem.
		curr_problem = current_problem
		
		if current_user.seen_problems.include?(curr_problem)
			relation=current_user.relation_of(curr_problem) 
		else 
			relation=current_user.user_problem_relations.create!(seen_problem_id: curr_problem.id)
		end
		return relation
  end
  
  def check_user_id(user_id)
		return ( User.where(id: user_id).count != 0 )
  end



#GLOBAL FUNCTIONS!!!!
	#methods for some values
	
	#returns the value of the problem depending on its length and difficulty
	#its used in competitions controller to calculate the relative percent of each problem given on a competition
	def value_problem(problem)
		value=problem.difficulty * problem.length
		return value
	end
	
	
	 def submit_2(competition)
		if !competition.finished?
			problems=competition.problems
			unsubmitted_users=competition.users.where(submitted_competition: false)
			#each unsubmitted user do
			unsubmitted_users.each do |uu|
				uu.submitted_at=Time.now
				uu.submitted_competition=true
				if @competition.entry_gold >= 500
					uu.increment(:number_premium_games)
				else
					uu.increment(:number_free_games)
				end
				#set the answers of all problems to 0
				problems.each do |p|
					uu.results["answer_#{p.id}"][:answer]=0
					uu.results["answer_#{p.id}"][:degree_of_answer]=0
					uu.results["answer_#{p.id}"][:check_answer]=false
				end
				uu.save!
				uu.reload #???
				#create user-problem relations
				create_relations(@competition, uu)
			end
			
			if (competition.users.where(submitted_competition: true).count == competition.n_players) && !competition.finished?
				if !final_submit_do(competition).nil?
					competition.update_attributes!(finished: true)
				end
			end
			#blabla
		end
  end
  
  
  def final_submit_do(competition)
		ActiveRecord::Base.transaction do	
			rank_players(@competition)											
			#gold transactions (bank to competitors and authors of problems)	
			if @competition.entry_gold > 0
				gold_transactions(@competition)
			end		
			#change the LVLs of the players
			calculate_lvls(@competition)
		end
  end
  
  
end
