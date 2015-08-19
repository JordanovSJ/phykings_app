class Bank < ActiveRecord::Base
	
	validates :present_gold, presence: true, :numericality => { :only_integer => true, :greater_than => -1 }
	validates :total_gold, presence: true, :numericality => { :only_integer => true, :greater_than => -1}
	#validate :bank_id1
	validate :total_present

	#~ #obvious
	#~ def Bank.withdraw(gold)
		#~ bank=Bank.access
		#~ if gold <= bank.present_gold && gold > 0
			#~ bank.present_gold -= gold
			#~ bank.save!
		#~ else 
			#~ return false
		#~ end
	#~ end
	#~ 
	#~ #obvious
	#~ def Bank.deposit(gold)
		#~ bank=Bank.access
		#~ if gold > 0
			#~ bank.present_gold += gold
			#~ bank.save!
		#~ else 
			#~ return false
		#~ end
	#~ end
	
	#returns the instance of the Bank model
	def Bank.access
		 if Bank.count==1
				Bank.first
			else
				Bank.create!(present_gold: 0, total_gold: 0)
			end
	end
	
	private
	
	#~ def bank_id1
		#~ errors.add(:id ,  "You can only have one bank")  unless Bank.count == 0
	#~ end
	#~ 
	
	def total_present
		errors.add(:present_gold , "Balance")  unless self.present_gold <= self.total_gold
	end
	
	

end
