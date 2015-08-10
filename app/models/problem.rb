class Problem < ActiveRecord::Base
	belongs_to :creator, class_name: 'User'
	
	#see user.rb for comments
	has_many :user_problem_relations, :foreign_key => 'seen_problem_id',
						:dependent => :destroy						
	has_many :viewers, :through => :user_problem_relations 
						
						
						
	validates :answer, presence: true
	validates :content, presence: true, length: { maximum: 3000 }
  validates :title, presence: true, length: { maximum: 100 }
  default_scope -> { order(created_at: :desc) }
	

end
