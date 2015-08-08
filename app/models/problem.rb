class Problem < ActiveRecord::Base
	belongs_to :creator, class_name: 'User'
	
	has_many :relations, :foreign_key => 'solved_problem_id',
						:dependent => :destroy
						
	has_many :solvers, :through => :relations #class_name: 'User',
						
						
						
	validates :answer, presence: true
	validates :content, presence: true, length: { maximum: 3000 }
  validates :title, presence: true, length: { maximum: 100 }
  default_scope -> { order(created_at: :desc) }
	

end
