module ApplicationHelper

	# Returns the current problem. This function was originally used in the
	# solutions controller, where it expected params[:problem_id].
	# Now the function is used also in the problems controller where the
	# expected parameter is params[:id].
	def current_problem
		if params.has_key?(:problem_id)
			@current_problem=Problem.find(params[:problem_id])
		elsif params.has_key?(:id)
			@current_problem=Problem.find(params[:id])
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

	#methods for some values
	
	#returns the value of the problem depending on its length and difficulty
	#its used in competitions controller to calculate the relative percent of each problem given on a competition
	def value_problem(problem)
		value=problem.difficulty * problem.length
		return value
	end
end
