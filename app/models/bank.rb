class Bank < ActiveRecord::Base
	#~ validate :must_exist_1_bank
	#~ 
	#~ def must_exist_1_bank
		  #~ errors.add_to_base "You can only have one bank"  unless Bank.count==0
	#~ end
	
	validates :present_gold, presence: true, :numericality => { :greater_than => 0}
	validates :total_gold, presence: true, :numericality => { :greater_than => 0}
	validate :bank_id1
	validate :total_present

	
	def Bank.access
		 Bank.find(1)
	end
	
	private
	
	def bank_id1
		errors.add(:id ,  "You can only have one bank")  unless Bank.count == 0
	end
	
	def total_present
		errors.add(:present_gold , "Balance")  unless self.present_gold <= self.total_gold
	end
end
