class Competition < ActiveRecord::Base
	has_many :users
	
	has_many :competition_problems, :foreign_key => 'competition_id',
						:dependent => :destroy	
	has_many :problems, :through => :competition_problems 
	
	
	validates :length, presence: true, inclusion: {in: LENGTH_COMPETITION}
	validates :entry_gold, presence: true, :numericality => { :only_integer => true, :greater_than => -1}
	validates :n_players, presence: true, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 21}
	#~ validate :problems_length_match
	
	
	private
	
	#~ def problems_length_match
		#~ errors.add(:length , "Balance")  unless problems_length == self.length
	#~ end
	#~ 
	#~ def problems_length
		#~ prob_length=0
		#~ self.problems.each do |p|
			#~ prob_length +=p.length
		#~ end
		#~ return prob_length
	#~ end
end
