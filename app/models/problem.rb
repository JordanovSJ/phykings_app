class Problem < ActiveRecord::Base
	belongs_to :creator, class_name: 'User'
	
	#see user.rb for comments
	has_many :user_problem_relations, :foreign_key => 'seen_problem_id',
						:dependent => :destroy						
	has_many :viewers, :through => :user_problem_relations 
	
	has_many :competition_problems, :foreign_key => 'problem_id' #dependent => :destroy??
	has_many :competitions, :through => :competition_problems 
				
	#trial						
	has_many :solutions, :through => :user_problem_relations 
						
	validates :answer, presence: true
	validates :content, presence: true, length: { maximum: 3000 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :degree_of_answer, presence: true
  validates :units_of_answer, presence: true
  validates :category, presence: true, inclusion: {in: CATEGORY}
  validates :difficulty, presence: true, inclusion: {in: 1..MAX_DIFFICULTY}
  validates :length, presence: true, inclusion: {in: LENGTH}
  validates :target, presence: true, inclusion: { in: 1..3 }
  
  default_scope -> { order(created_at: :desc) }
	

#methods
	#return the solution of problem submitted by the user, if there is no such solutions, returns nil
	def solution_of(user)
		if self.viewers.include?(user)
			return self.user_problem_relations.find_by(viewer_id: user.id).solution
		end
	end
end
