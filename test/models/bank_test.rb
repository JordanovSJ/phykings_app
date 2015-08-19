require 'test_helper'

class BankTest < ActiveSupport::TestCase

	test "bank.access is valid" do
		Bank.access.valid?
	end
	 
	
		#~ test "cannot create a second bank" do
			#~ assert_difference 'Bank.count', 1 do
				#~ Bank.access
			#~ end
			#~ assert_no_difference 'Bank.count' do
				#~ Bank.create(present_gold: 10,total_gold: 10)
			#~ end
		#~ end
		
	
		
end
