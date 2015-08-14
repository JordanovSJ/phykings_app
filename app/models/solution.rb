class Solution < ActiveRecord::Base
	belongs_to :user_problem_relation
	has_one :viewer, :through=> :user_problem_relation
	has_one :seen_problem, :through=> :user_problem_relation
	
	validates :content, presence: true, length: { maximum: 3000 }
	validates :user_problem_relation_id, presence: true
	validates :answer, presence: true
	validates :degree_of_answer, presence: true

	#methods
	
	#check if the numerical answer of the solution is within an interval of +-5% the value of the numerical answer of the problem
	def check_answer
		value_answer_solution=(self.answer)*10**(self.degree_of_answer)
		problem=self.problem
		value_answer_problem=(problem.answer)*10**(problem.degree_of_answer)
		upper_bound=value_answer_problem*1.05
		lower_bound=value_answer_problem*0.95
		return (value_answer_solution <= upper_bound && value_answer_solution >= lower_bound)
	end
	
	#additional names for convieniencee
	def user 
		self.viewer
	end
	
	def problem
		self.seen_problem
	end
end
