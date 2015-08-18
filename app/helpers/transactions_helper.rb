module TransactionsHelper
	#~ def transaction_user_to_bank(gold)
			#~ ActiveRecord::Base.transaction do
				#~ present_gold=Bank.access.present_gold + gold
				#~ Bank.access.update_attributes!(present_gold: present_gold)
				#~ user_gold=current_user.gold - gold
			#~ current_user.update_attributes!(gold: user_gold)
		#~ end
	#~ end
	#~ 
	#~ def transaction_bank_to_user(gold) #add user??
		#~ ActiveRecord::Base.transaction do
			#~ present_gold=Bank.access.present_gold - gold
			#~ Bank.access.update_attributes!(present_gold: present_gold)
			#~ user_gold=current_user.gold + gold
			#~ current_user.update_attributes!(gold: user_gold)
		#~ end
	#~ end
end
