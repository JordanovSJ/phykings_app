module CompetitionsHelper
	
	#determines the ranks of the users after submission
	def rank_players(competition)
		users=competition.users
		sorted_users = (users.sort_by{|u| user_percents(u)}.reverse).sort_by{|u| u.submitted_at}
		count=0
		rank=1
		sorted_users.each do |u|
			#if two or more users have the same result and submit at the end of the competition they must have equal ranks!!!
			if count > 0 
				previous_user=sorted_users[count-1]
				#check if both the user's percents and submitted time are equal to the those of the previous user and if not it change the rank +1
				#if they are percents and the times are equal the rank is not changed!!!
				if user_percents(previous_user) != user_percents(u) || u.submitted_at != previous_user.submitted_at #balta6tina
					rank = count+1
				end
			end
			u.results[:rank]=rank
			u.save!
			count += 1
		end	
	end
	
	#create the relations between players and problems after a everyone submit the answers of a compeittion
	def create_relations(competition, user)
		problems=competition.problems
		#boolean value
		premium= competition.entry_gold >= 500 
		results=user.results
		problems.each do |p|
			if user.relation_of(p).nil?
				relation=UserProblemRelation.new(seen_problem_id: p.id, viewer_id: user.id)
			else
				relation=user.relation_of(p)
			end
			
			if premium
				relation.attempted_during_premium=true
				if results["answer_#{p.id}"][:check_answer]
					relation.solved_during_premium=true
				end
			else
				relation.attempted_during_free=true
				if results["answer_#{p.id}"][:check_answer]
					relation.solved_during_free=true
				end
			end
			relation.save!
		end
	end
	
	
#PRIVATE!!!
	private
	
	#calculates the result in percents of a user after sumbmission
	def user_percents(user)
		competition=Competition.find(user.competition_id)
		problems_percents=competition.problems_percents
		problems=competition.problems
		user_results=user.results
		user_perc=0

		problems.each do |p|
			if user.results["answer_#{p.id}"][:check_answer]
				user_perc += problems_percents["percent_problem_#{p.id}"]
			end
		end
		
		return user_perc
	end
	
end
