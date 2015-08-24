class Competition < ActiveRecord::Base
	serialize :problems_percents, Hash

	has_many :users
	
	has_many :competition_problems, :foreign_key => 'competition_id',
						:dependent => :destroy	
	has_many :problems, :through => :competition_problems 
	
	
	validates :length, presence: true, inclusion: {in: LENGTH_COMPETITION}
	validates :entry_gold, presence: true, :numericality => { :only_integer => true, :greater_than => -1}
	validates :n_players, presence: true, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 21}

	
	
	private
	

end
