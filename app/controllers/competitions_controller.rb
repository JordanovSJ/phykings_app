class CompetitionsController < ApplicationController
	include TransactionsHelper
	include ApplicationHelper
	include CompetitionsHelper
	
	before_action :logged_in_user
	before_action :check_for_id, only: [:show]
	before_action :not_in_competition, only: [:create, :new, :show]
	before_action :belongs_to_competition, only: [:show]
	before_action :enough_gold, only: [:show, :create]
	
	
  def index
		@competitions = Competition.all
  end
    
  def show
		@competition=Competition.find(params[:id])
		# When the competition is still not full
		if @competition.users.count < @competition.n_players && current_user.competition_id.nil?
			current_user.update_attributes!(competition_id: params[:id])
			transaction_user_to_bank(@competition.entry_gold, current_user)
		end

		#when the last player joins the competition, find problems for the comepetition
		if  @competition.users.count == @competition.n_players
		
			# Start the comeptition if it has not started yet
			if @competition.started_at.nil?
				@competition.update_attributes(started_at: Time.now)
			end
		
			# Find problems only once.
			if @competition.problems.empty?
				choose_problems(@competition)
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
		if ( (Time.now - @competition.started_at) > @competition.length * 60 ) && !current_user.submitted_competition
			@submit_params = {}
			@competition.problems.each do |p|
				if session["answer_#{p.id}"].present?
					@submit_params["answer_#{p.id}"] = session["answer_#{p.id}"]
				else
					@submit_params["answer_#{p.id}"] = {answer:0, degree_of_answer:0}
				end
			end
			redirect_to submit_competitions_path( submit_params: @submit_params )
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
		@answer = params[:answer]
		if ( @answer[:degree_of_answer].present? && @answer[:answer].present? )
			session["answer_#{params[:problem_id]}"] = params[:answer]
			flash[:success] = "Answer saved successfully. You can always come back and change it if you want."
			redirect_to competition_path(Competition.find(params[:id]))
		else
			flash[:danger] = "Answer not saved. Please make sure you have filled all required fields of the answer."
			redirect_to competition_path(Competition.find(params[:id]))
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
								
			#when the competition is over (everyone have submitted answers): 
			#ranking
			#gold transactions, if any
			#change of lvl
			if @competition.users.where(submitted_competition: true).count == @competition.n_players
				#determine the ranks of the individual players
				rank_players(@competition)
				
				#TODO: gold transactions (bank to competitors and authors of problems)
				
				#TODO: calculate the change of LVLs
			end
			
			redirect_to competition_path(Competition.find(params[:id]))
		else
			flash[:danger] = "You have already submitted your answers."
			redirect_to competition_path(Competition.find(params[:id]))
		end
		
  end
  
  #leave competition, after submit
  def leave
  
  end
  
  
#PRIVATE!!!
  private
  
	def competition_params
	 params.require(:competition).permit(:n_players, :length, :entry_gold)
  end

	#consider to move in competition_helper

  #chosee random problems for the competition whose total length is equal
  #to the length of the competition
  #problems unseen by the competitors are prefered!
  def choose_problems(competition)
		users=competition.users
		unseen_problems=Problem.all
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
				problem=Problem.all.select{ |p| p.length <= max_length && !competition.problems.include?(p)}.sample
				#to be removed in future, cause unneccessery
				if problem.nil?
					flash[:danger]="Couldnt find problems!"
					@competition=Competition.find(params[:id])
					@competition.users.each do |u|
						u.update_attributes!(competition_id: nil)
					end
					@competition.destroy
					redirect_to competitions_path
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
		unless competition.users.include?(current_user) || competition.users.count < competition.n_players
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