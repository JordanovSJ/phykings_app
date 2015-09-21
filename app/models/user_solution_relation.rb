class UserSolutionRelation < ActiveRecord::Base
	belongs_to :viewer, class_name: 'User'
	belongs_to :seen_solution, class_name: "Solution"

	validates :seen_solution_id, presence: true
	validates :viewer_id, presence: true
end
