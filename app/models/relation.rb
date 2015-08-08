class Relation < ActiveRecord::Base
	belongs_to :solver, class_name: 'User'
	belongs_to :solved_problem, class_name: "Problem"
	
	
	validates :user_id, presence: true
	validates :problem_id, presence: true
	
end
