class CompetitionsController < ApplicationController
	include TransactionsHelper
	include ApplicationHelper
	include CompetitionsHelper
	
	before_action :logged_in_user
	before_action :check_for_id, only: [:show]
	before_action :not_in_competition, only: [:create, :new, :show]
	before_action :belongs_to_competition, except: [:create, :new, :index, :refresh_index_table]
	before_action :enough_gold, only: [:show, :create]
	before_action :not_finished, except: [:create, :new, :index, :refresh_index_table]
	
  def index
		@competitions = Competition.all
  end
  
  #~ Used to refresh the #active-competition-table on the index page.
  def refresh_index_table
		@competitions = Competition.all
		respond_to do |format|
			format.js
		end
  end
    
  def show
		@competition=Competition.find(params[:id])
		# When the competition is still not full
		if ( @competition.users.count < @competition.n_players ) && current_user.competition_id.nil?
			current_user.update_attributes!(competition_id: params[:id])
			transaction_user_to_bank(@competition.entry_gold, current_user)
		end

		#when the last player joins the competition, find problems for the comepetition
		if  @competition.users.count == @competition.n_players || @competition.finished?
		
			# Start the comeptition if it has not started yet
			if @competition.started_at.nil?
				@competition.update_attributes(started_at: Time.now)
			end
		
			# Find problems only once.
			if @competition.problems.empty?
				choose_problems(@competition)
				#prevents sa6o bug
				if @competition.nil?
					redirect_to competitions_path
				end
			end
			
			@problems = @competition.problems
			@users = @competition.users
			
			if @competition.problems_percents.empty?
				@competition.update_attributes!(problems_percents: evaluate_problems(@competition))
			end
			@problems_percents=@competition.problems_percents
			
			# If problem_id is present then show the chosen problem
			if params.has_key?(:problem_id)
				@problem = Problem.find(params[:problem_id])
			end
						
			# Decides whether the submit button should be disabled
			@allow_submit = true
			@problems.each do |prob|
				unless session.has_key?("answer_#{prob.id}")
					@allow_submit = false
				end
			end
		end
		
		# If the time has run out, submit the competition
		if @competition.started_at?
			time_since_end = (Time.now - @competition.started_at) - @competition.length * 60
		end
		
		if @competition.started_at? && ( time_since_end >= 0 ) && !@competition.finished
			if time_since_end < 60 && !current_user.submitted_competition
				@submit_params = {}
				@competition.problems.each do |p|
					if session["answer_#{p.id}"].present?
						@submit_params["answer_#{p.id}"] = session["answer_#{p.id}"]
					else
						@submit_params["answer_#{p.id}"] = {answer:0, degree_of_answer:0}
					end
				end
				redirect_to submit_competitions_path( submit_params: @submit_params )
			elsif time_since_end >=60
				#dachko_submit
				if submit_2( @competition )
					#@ranked_users = @competition.users.sort_by { |u| u.results[:rank] } #<------
					redirect_to competition_path( @competition )
				else
					@competition.update_attributes!(finished: true)
					flash[:danger] = "Something went wrong."
					#@ranked_users = @competition.users.sort_by { |u| u.results[:rank] } #<------
					redirect_to competition_path( @competition )
				end
			end
		end
		
		# Sorted users by rank
		if @competition.users.where(submitted_competition: false).count == 0
			@ranked_users = @competition.users.sort_by { |u| u.results["rank"] }
		end

  end
  
  def new
		@competition=Competition.new
  end
  
  def create
		@competition=Competition.new(competition_params)
		if @competition.save
			current_user.update_attributes!(competition_id: @competition.id)
			transaction_user_to_bank(@competition.entry_gold, current_user)
			flash[:success]="You successfully created a competition. Good luck!"
			redirect_to competition_path(@competition)
		else
			render 'new'
		end
  end
  
  # In competition, shows the selected problem from the list of chosen problems.
  def show_problem
		@problem = Problem.find(params[:problem_id])
		redirect_to competition_path(Competition.find(params[:id]), problem_id: @problem.id)
  end
  
  # Saves the answer of the current problem in session.
  def submit_answer
		competition = Competition.find(params[:id])
		remaining_time = competition.length*60 - (Time.now - competition.started_at)
		if remaining_time > 0
			@answer = params[:answer]
			if ( @answer[:degree_of_answer].present? && @answer[:answer].present? )
				session["answer_#{params[:problem_id]}"] = params[:answer]
				flash[:success] = "Answer saved successfully. You can always come back and change it if you want."
				redirect_to competition_path(competition)
			else
				flash[:danger] = "Answer not saved. Please make sure you have filled all required fields of the answer."
				redirect_to competition_path(competition)
			end
		else
			flash[:danger] = "Time is over. You cannot save answers any more."
			redirect_to competition_path(competition)
		end
  end
  
  #submit answers
  def submit
		if !current_user.submitted_competition?
			@results = params[:submit_params]
			@competition = Competition.find(params[:id])
			
			@competition.problems.each do |prob|
				@results["answer_#{prob.id}"][:check_answer] = Solution.check_answer(@results["answer_#{prob.id}"], prob)
			end
		
			current_user.update_attributes(results: @results)
			current_user.update_attributes(submitted_at: Time.now)
			current_user.update_attributes(submitted_competition: true)

			if @competition.entry_gold >= 500
				current_user.increment(:number_premium_games).save!
			else
				current_user.increment(:number_free_games).save!
			end

			#create user-problem relations
			create_relations(@competition, current_user)
				
			#when the competition is over (everyone have submitted answers): 
			#ranking
			#gold transactions, if any
			#change of lvl
			if @competition.users.where(submitted_competition: true).count == @competition.n_players
				@competition.update_attributes!(finished:	true)			
							#~ #FOR TEST PURPOSES!!!!/////////
							#~ #/////////////////////////////
							#~ @competition.users.each do |u|
								#~ u.update_attributes!(submitted_at: 42)
							#~ end
							#~ #//////////////////////////////
							#~ #/////////////////////////////	
								
				#determine the ranks of the individual players	
				rank_players(@competition)											
				#gold transactions (bank to competitors and authors of problems)
			
				if @competition.entry_gold > 0
					gold_transactions(@competition)
				end
				
				#change the LVLs of the players
				calculate_lvls(@competition)
			end			
			redirect_to competition_path(Competition.find(params[:id]))
		else
			flash[:danger] = "You have already submitted your answers."
			redirect_to competition_path(Competition.find(params[:id]))
		end		
  end
  
  #leave competition, after submit
  def destroy
		@competition=Competition.find(params[:id])
		if @competition.finished? || @competition.started_at.nil?
			users=@competition.users
			current_user.competition_id=nil
			current_user.submitted_at=nil
			current_user.submitted_competition= false
			current_user.results={}
			current_user.save!
			
			if current_user.can_get_free_gold
				current_user.notifications.create!( message: "Congratulations! You are now entitled to 1000 gold free gift." )
			end
			
			if users.count == 0
				@competition.destroy
			end
			redirect_to competitions_path
		else
			flash[:danger]="You cannot leave when competition is started and not finished!!!"
			redirect_to comepetition_path(@competition)
		end
  end
  
  
#PRIVATE!!!
  private
  
	def competition_params
	 params.require(:competition).permit(:n_players, :length, :entry_gold, :target)
  end

	#consider to move in competition_helper

  #choses random problems for the competition whose total length is equal
  #to the length of the competition
  #problems unseen by the competitors are prefered!
  def choose_problems(competition)
		users=competition.users
		case competition.target
		when 1
			problems=Problem.all.where(target: 1)
		when 2
			problems=Problem.all.where(target: 2)
		when 3
			problems=Problem.all.where(target: 3)
		else
			problems=Problem.all
		end	
		checked_problems=problems.where(checked: true)  #<-- add checked
		unseen_problems=checked_problems
		users.each do |u|
			unseen_problems=unseen_problems.select{ |p| !p.viewers.include?(u)}
		end 
		problems_length=0
		problem=nil
		while problems_length < competition.length do
			max_length=competition.length-problems_length
			problem=nil
			problem=unseen_problems.select{ |p| p.length <= max_length && !competition.problems.include?(p)}.sample #balta6tina
			if problem.present?
				problems_length += problem.length
				competition.competition_problems.create!(problem_id: problem.id)
			else
				problem=checked_problems.select{ |p| p.length <= max_length && !competition.problems.include?(p)}.sample
				#to be removed in future, cause unneccessery
				if problem.nil?
					flash[:danger]="Couldnt find problems!"
					@competition=Competition.find(params[:id])
					@competition.users.each do |u|
						u.update_attributes!(competition_id: nil)
					end
					@competition.destroy
					#redirect_to competitions_path
					return false
				end
				#//
				problems_length += problem.length
				competition.competition_problems.create!(problem_id: problem.id)
			end
		end	
  end

	#consider to move in competition_helper
	
	#return hash of the relative values of each of the problems in percents (integers)
	def evaluate_problems(competition)
		total_value=0
		problems=competition.problems
		problems.each do |p|
			total_value += value_problem(p)
		end
		hash_percents={}
		#balta6tina!
		#the reason for the next line is to make sure that the sum of the percents of the problems is always 100
		last_problem_percent=100
		count=1
		problems.each do |p|
			if count < problems.count
				percent=((value_problem(p).to_f / total_value)*100).round(0).to_i
				hash_percents["percent_problem_#{p.id}"]=percent
				last_problem_percent -= percent
				count += 1
			else
				hash_percents["percent_problem_#{p.id}"]=last_problem_percent
			end
		end
		return hash_percents
	end

#BEFORE ACTIONS!!!!

	def not_finished
		@competition=Competition.find(params[:id])
		if @competition.finished && (current_user.competition_id.nil? || current_user.competition_id != @competition.id)
			flash[:danger]="This competition is over!!!"
			redirect_to competitions_path
		end
	end	

	#checks if params[:id] exist
  def check_for_id
		if Competition.where(id: params[:id]).count==0
			flash[:danger]="This competition does not exist"
			redirect_to competitions_path
		end
  end

  #user cannot participate in a competition if already participate in another!!!
  def not_in_competition
		if current_user.competition_id.present? && !(current_user.competition_id==params[:id].to_i)
			flash[:danger]="You cannot participate in more than one competitio at a time!!!"
			redirect_to competition_path(current_user.competition_id)
		end
  end

	#user cannot see foreign competitions
	def belongs_to_competition
		competition=Competition.find(params[:id])
		unless competition.users.include?(current_user) || (competition.users.count < competition.n_players && competition.started_at.nil?)
			flash[:danger]="This competition is already full !!!"
			redirect_to competitions_path
		end
	end
  
  #check if user has enough gold to create or enter a competition
  def enough_gold
		if params[:id].present?
			entry_gold=Competition.find(params[:id]).entry_gold  #in case of show action
		else
			entry_gold=competition_params[:entry_gold].to_i			 #in case of create action
		end		
		if current_user.competition_id.nil? && current_user.gold < entry_gold
			flash[:danger]="You dont have enough gold!!!"
			redirect_to competitions_path
		end
  end
end
