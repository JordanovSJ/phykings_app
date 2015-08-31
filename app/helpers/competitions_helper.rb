module CompetitionsHelper
	include ApplicationHelper
	
	#determines the ranks of the users after submission
	def rank_players(competition)
		users=competition.users
		sorted_users = users.sort_by{|u| [(100 - user_percents(u)), u.submitted_at]}
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
		premium= competition.entry_gold >= MIN_PREMIUM_ENTRY_GOLD 
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
	
	#sends gold to the winners of the competition and the authors of the problems
	def gold_transactions(competition)
		correct_answer=false
		competition.users.each do |u|
			if user_percents(u) != 0
				correct_answer=true
			end
		end
		# if no correct problems all gold for us
		all_gold=competition.entry_gold * competition.n_players
		prizes_gold= ((1.0 - (COMPETITION_PERCENT_FOR_US + COMPETITION_PERCENT_FOR_CREATORS)) * all_gold).to_i
		creators_gold= (COMPETITION_PERCENT_FOR_CREATORS * all_gold).to_i
		if correct_answer
			creators_get_gold(competition, creators_gold)
			players_get_gold(competition, prizes_gold)	
		else
			creators_get_gold(competition, creators_gold)
			#players get pi6ka v ustata
		end
	end
	
	#calculate the change in the lvl of each of the competitors and save it
	def calculate_lvls(competition)
		if competition.entry_gold >= MIN_PREMIUM_ENTRY_GOLD
			premium=true
		else
			premium=false
		end
		competition.users.each do |u|
			lvl_change=rank_lvl_change(u, premium) + problems_lvl_change(u) 
			u.results[:lvl_change]=lvl_change
			if premium
				u.increment(:premium_level, lvl_change )
				u.save!
				u.notifications.create!(message: "You participated in a competition with non-zero entry gold(premium competition). Your premium level has changed by <span class='label label-success'>#{lvl_change}</span>.")
			else
				u.increment(:free_level, lvl_change )
				u.save!
				u.notifications.create!(message: "You participated in a competition with no entry gold(free competition). Your free level has changed by <span class='label label-default'>#{lvl_change}</span>.")
			end
		end
	end
	
	def user_score(user, competition)
		score = 0
		competition.problems.each do |prob|
			if user.results["answer_#{prob.id}"]["check_answer"]
				score += competition.problems_percents["percent_problem_#{prob.id}"]
			end
		end
		return score
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
	
	
	def creators_get_gold(competition, gold)
		problems=competition.problems
		sum_to_pay=(gold.to_f / problems.count).to_i
		problems.each do |p|
			transaction_bank_to_user(sum_to_pay, p.creator)
			p.creator.notifications.create!(message: "One of your problems was given at a competition with non-zero entry gold. You have been awarded with #{sum_to_pay} gold. Keep up the good work! :)")
		end		
	end
	
	def players_get_gold(competition, gold)
		users=competition.users
		#sorted by rank 
		sorted_users=users.sort_by{|u| u.results[:rank]}
		max_rank=sorted_users.reverse.first.results[:rank]		
		if max_rank==1
			sum_to_pay=gold / users.count
			users.each do |u|
				transaction_bank_to_user(sum_to_pay, u)
				u.results["gold_change"] = sum_to_pay
				u.notifications.create!(message: "You did well in a competition with non-zero entry gold. You have won #{sum_to_pay} gold.")
			end
			return true
		end	
		# determines the maximum rank that should receive some gold
		not_found = true
		max_winning_rank=max_rank-1
		while not_found do
			users_max_rank=users.select{|u| u.results[:rank] == max_winning_rank}
			if (users_max_rank.count != 0) && (user_percents(users_max_rank.first) != 0)
				not_found=false
			else
				max_winning_rank -= 1
			end
		end
		parts=0	
		(1..max_winning_rank).each do |rank|
			n_ranks=users.select{|u| u.results[:rank]==rank}.count
			degree=max_winning_rank - rank
			n_parts = BASE_GOLD_FUN ** degree
			parts += n_parts * n_ranks
		end	
		part_value= gold.to_f / parts
		#the number of players with rank 1
		n_rank1=users.select{|u| u.results[:rank]==1}.count
		sorted_users.select{|u| u.results[:rank] <= max_winning_rank}.reverse.each do |u|
			rank=u.results[:rank]
			if rank != 1
				degree=max_winning_rank - rank
				n_parts = BASE_GOLD_FUN ** degree
				sum_to_pay=(n_parts * part_value).to_i
				gold -= sum_to_pay
				transaction_bank_to_user(sum_to_pay, u)
				u.results["gold_change"] = sum_to_pay
				u.notifications.create!(message: "You did well in a competition with non-zero entry gold. You have won #{sum_to_pay} gold.")
			else
				sum_to_pay = gold / n_rank1
				transaction_bank_to_user(sum_to_pay, u)
				u.results["gold_change"] = sum_to_pay
				u.notifications.create!(message: "Congratulations! You ranked first in a competition with non-zero entry gold. You have won #{sum_to_pay} gold.")
			end
		end	
	end
	
	def problems_lvl_change(user)
		competition = Competition.find(user.competition_id)
		problems=competition.problems
		lvl_change=0
		problems.each do |p|
			if user.results["answer_#{p.id}"][:check_answer]
				lvl_change += (p.difficulty * p.length * MAX_EXP_CHANGE_PROBLEM) / (MAX_DIFFICULTY * LENGTH.last)
			else
				lvl_change -= ((11 - p.difficulty) * p.length * MAX_EXP_CHANGE_PROBLEM) / (MAX_DIFFICULTY * LENGTH.last)
			end
		end
		return lvl_change
	end
	
	def rank_lvl_change(user, premium)
		if premium
			user_lvl=user.premium_level
		else
			user_lvl=user.free_level
		end		
		competition=Competition.find(user.competition_id)
		users=competition.users
		sorted_users=users.sort_by{|u| u.results[:rank]}
		median_rank=get_median_rank(sorted_users)
		delta_rank= median_rank - user.results[:rank] # <--- delta rank; FLOAT!!!
		
		lvl_sum=0
		users.each do |u|
			if premium
				lvl_sum += u.premium_level
			else
				lvl_sum += u.free_level
			end
		end
		average_lvl=lvl_sum.to_f / users.count # <--- average_lvl
		if delta_rank > 0
			delta_lvl= (average_lvl - user_lvl.to_f) / BASE_EXP
		else
			delta_lvl= (user_lvl.to_f - average_lvl) / BASE_EXP
		end

		lvl_change=(RANK_LVL_CHANGE_COEFF * delta_rank * (BASE_RANK_EXP ** delta_lvl)).to_i
		return lvl_change
	end
	
	def get_median_rank(sorted_users)
		n_players=sorted_users.count
		if (n_players % 2) ==0
			mid_player1=sorted_users[(n_players / 2) - 1]
			mid_player2=sorted_users[n_players / 2]
			median_rank=(mid_player1.results[:rank] + mid_player2.results[:rank]).to_f / 2
		else
			mid_player=sorted_users[n_players / 2]
			median_rank=mid_player.results[:rank]
		end
		return median_rank
	end
end
