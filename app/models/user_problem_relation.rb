class UserProblemRelation < ActiveRecord::Base
	belongs_to :viewer, class_name: 'User'
	belongs_to :seen_problem, class_name: "Problem"
		
	validates :viewer_id, presence: true
	validates :seen_problem_id, presence: true
	
end
