class Relation < ActiveRecord::Base
	belongs_to :solver, class_name: 'User'
	belongs_to :solved_problem, class_name: "Problem"
		
	validates :solver_id, presence: true
	validates :solved_problem_id, presence: true
	
end
