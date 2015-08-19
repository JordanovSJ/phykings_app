require 'test_helper'

class BankTest < ActiveSupport::TestCase

	def setup	
		@user1=users(:go6o) # creator of the problem
		@user2=users(:pe6o) #solver of the problem
		#@user3=users(:stamat) #has not relation to the problem
		@problem=problems(:problem1_by_user1)
		@relation=get_custom_relation(@user2,@problem)
		@solution=get_custom_solution(@relation)
		@problem_params=get_params_for_problem
		@solution_params=get_params_for_solution
	end
	

	test "bank.access is valid" do
		Bank.access.valid?
	end
	 
	
		
	test "unlock solutions of problem" do
		@relationCreator=get_custom_relation(@user1,@problem)
		@solutionCreator=get_custom_solution(@relationCreator) 
		assert_not @user2.relation_of(@problem).can_see_solution
		bank=Bank.access
		bank.total_gold += 1000
		bank.save!
		@user2.gold += 500
		@user2.save!
		@user2.unlock_solutions_of(@problem)
		@user2.reload
		assert @user2.relation_of(@problem).can_see_solution
		assert @user2.gold==225 , "#{@user2.gold}"
		assert Bank.access.present_gold== 50, "#{Bank.access.present_gold}"
		assert @user1.gold=225
	end
	
	test "unlock answer oof problem" do
		bank=Bank.access
		bank.total_gold += 1000
		bank.save!
		@user2.gold += 500
		@user2.save!
		assert_not @user2.relation_of(@problem).can_see_answer
		@user2.unlock_answer_of(@problem)
		@user2.reload
		assert @user2.relation_of(@problem).can_see_answer
		assert @user2.gold==400
		@user1.reload
		assert @user1.gold==90 , "#{@user1.gold}"
		assert Bank.access.present_gold== 10
	end
end
