class CompetitionsController < ApplicationController
  def index
  end
    
  def show
		@competition=Competition.find(params[:id])
		if @competition.users.count < @competition.n_players
			current_user.update_attributes!(competition_id: params[:id])
			respond_to do |format|
				format.js
				format.html
			end
		else
			respond_to do |format|
				format.js
				format.html {redirect_to root_path }
			end
		end
  end
  
end
