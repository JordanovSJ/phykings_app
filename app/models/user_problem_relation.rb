class UserProblemRelation < ActiveRecord::Base
	belongs_to :viewer, class_name: 'User'
	belongs_to :seen_problem, class_name: "Problem"
	has_one :solution, :dependent => :destroy		 #conditions: provided_with_solution
	
	validates :viewer_id, presence: true
	validates :seen_problem_id, presence: true
	
	private
	

	
end
