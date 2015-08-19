module TransactionsHelper
	def transaction_user_to_bank(gold,user)
		ActiveRecord::Base.transaction do
			Bank.access.increment(:present_gold, gold).save!
			user.increment(:gold, - gold).save!
		end
	end
	
	def transaction_bank_to_user(gold,user)
		ActiveRecord::Base.transaction do
			Bank.access.increment(:present_gold, - gold).save!
			user.increment(:gold, gold).save!
		end
	end
end
