class Solution < ActiveRecord::Base
	belongs_to :user_problem_relation

	
	validates :content, presence: true, length: { maximum: 3000 }
end
