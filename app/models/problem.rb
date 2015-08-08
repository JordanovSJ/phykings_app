class Problem < ActiveRecord::Base
	belongs_to :creator, class_name: 'User'
	
	#~ has_many :relations
	#~ has_many :solvers, class_name: 'User',
						#~ :through => :relations
	
	validates :content, presence: true, length: { maximum: 3000 }
  validates :title, presence: true, length: { maximum: 100 }
  default_scope -> { order(created_at: :desc) }
	

end
