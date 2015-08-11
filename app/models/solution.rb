class Solution < ActiveRecord::Base
	belongs_to :user_problem_relation
	has_one :viewer, :through=> :user_problem_relation
	has_one :seen_problem, :through=> :user_problem_relation
	
	validates :content, presence: true, length: { maximum: 3000 }
	validates :user_problem_relation_id, presence: true
	
	#methods
	
	#additional names for convieniencee
	def user 
		self.viewer
	end
	
	def problem
		self.seen_problem
	end
end
