class CompetitionsController < ApplicationController
	
	before_action :logged_in_user
	before_action :check_for_id, only: [:show]
	before_action :not_in_competition, only: [:create, :new, :show]
	before_action :belongs_to_competition, only: [:show]
	
  def index
  end
    
  def show
		@competition=Competition.find(params[:id])
		if @competition.users.count < @competition.n_players && current_user.competition_id.nil?
			current_user.update_attributes!(competition_id: params[:id])
		end

		#when the last player joins the competition, find problems for the comepetition
		if  @competition.users.count == @competition.n_players
			choose_problems(@competition)
		end

  end
  
  def new
		@competition=Competition.new
  end
  
  def create
		@competition=Competition.new(competition_params)
		if @competition.save
			current_user.update_attributes!(competition_id: @competition.id)
			flash[:success]="You successfully created a competition. Good luck!"
			redirect_to competition_path(@competition)
		else
			render 'new'
		end
  end
  
  #submit answers
  def submit
		
  end
  
  #leave competition, after submit
  def leave
  
  end
  
  private
  
	def competition_params
	 params.require(:competition).permit(:n_players, :length, :entry_gold)
  end

  
  def choose_problems(competition)
		users=competition.users
		unseen_problems=Problem.all
		users.each do |u|
			unseen_problems=unseen_problems.select{ |p| !p.viewers.include?(u) }
		end
		
  end



#before actions

	#checks if params[:id] exist
  def check_for_id
		if Competition.where(id: params[:id]).count==0
			flash[:danger]="This competition does not exist"
			redirect_to competitions_path
		end
  end

  #user cannot participate in a competition if already participate in another!!!
  def not_in_competition
		if current_user.competition_id.present? && !(current_user.competition_id==params[:id])
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
  
end
