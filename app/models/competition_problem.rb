class CompetitionProblem < ActiveRecord::Base
	belongs_to :problem
	belongs_to :competition
	
	
	validates :problem_id, presence: true
	validates :competition_id, presence: true
	
end
