class Solution < ActiveRecord::Base
	#can be commented
	acts_as_commontable

	belongs_to :user_problem_relation
	has_one :viewer, :through=> :user_problem_relation
	has_one :seen_problem, :through=> :user_problem_relation
	
	mount_uploader :picture, SolutionPictureUploader
	
	validates :content, presence: true, length: { maximum: 3000 }
	validates :user_problem_relation_id, presence: true
	validates :answer, presence: true
	validates :degree_of_answer, presence: true
	validate :picture_size

	#methods
	
	#check if the numerical answer of the solution is within an interval of +-5% the value of the numerical answer of the problem
	def Solution.check_answer(params_solution,problem)
		value_answer_solution=((params_solution[:answer]).to_i)*10**((params_solution[:degree_of_answer]).to_i)
		value_answer_problem=(problem.answer)*10**(problem.degree_of_answer)
		upper_bound=value_answer_problem*(1.0 + MAX_ACPT_ERR)
		lower_bound=value_answer_problem*(1.0 - MAX_ACPT_ERR)
		return (value_answer_solution <= upper_bound && value_answer_solution >= lower_bound)
	end
	
	def answer_params
		{answer: self.answer, degree_of_answer: self.degree_of_answer}
	end
	
	#additional names for convieniencee
	def user 
		self.viewer
	end
	
	def problem
		self.seen_problem
	end
	
	private
	
		# Validates the size of an uploaded picture.
    def picture_size
      if picture.size > MAX_PIC_SIZE.kilobytes
        errors.add(:picture, "should be less than 500kB")
      end
    end
end
